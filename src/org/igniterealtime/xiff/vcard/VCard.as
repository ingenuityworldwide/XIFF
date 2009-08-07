/*
 * License
 */
package org.igniterealtime.xiff.vcard
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.xml.XMLNode;

	import mx.utils.Base64Decoder;

	import org.igniterealtime.xiff.core.UnescapedJID;
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.IQ;
	import org.igniterealtime.xiff.data.XMPPStanza;
	import org.igniterealtime.xiff.data.im.RosterItemVO;
	import org.igniterealtime.xiff.data.vcard.VCardExtension;
	import org.igniterealtime.xiff.events.VCardEvent;

	[Bindable]
	/**
	 *
	 */
	public class VCard extends EventDispatcher
	{
		/**
		 *
		 * @default
		 */
		private static var cache:Object = {};

		/**
		 * Flush the vcard cache every 6 hours
		 * @default
		 */
		private static var cacheFlushTimer:Timer = new Timer( 6 * 60 * 60 * 1000, 0 );

		/**
		 *
		 * @default
		 */
		private static var requestQueue:Array = [];

		/**
		 *
		 * @default
		 */
		private static var requestTimer:Timer;

		/**
		 *
		 * @default
		 */
		public var company:String;

		/**
		 *
		 * @default
		 */
		public var department:String;

		/**
		 *
		 * @default
		 */
		public var email:String;

		/**
		 *
		 * @default
		 */
		public var firstName:String;

		/**
		 *
		 * @default
		 */
		public var fullName:String;

		/**
		 *
		 * @default
		 */
		public var homeAddress:String;

		/**
		 *
		 * @default
		 */
		public var homeCellNumber:String;

		/**
		 *
		 * @default
		 */
		public var homeCity:String;

		/**
		 *
		 * @default
		 */
		public var homeCountry:String;

		/**
		 *
		 * @default
		 */
		public var homeFaxNumber:String;

		/**
		 *
		 * @default
		 */
		public var homePagerNumber:String;

		/**
		 *
		 * @default
		 */
		public var homePostalCode:String;

		/**
		 *
		 * @default
		 */
		public var homeStateProvince:String;

		/**
		 *
		 * @default
		 */
		public var homeVoiceNumber:String;

		/**
		 *
		 * @default
		 */
		public var jid:UnescapedJID;

		/**
		 *
		 * @default
		 */
		public var lastName:String;

		/**
		 *
		 * @default
		 */
		public var loaded:Boolean = false;

		/**
		 *
		 * @default
		 */
		public var middleName:String;

		/**
		 *
		 * @default
		 */
		public var nickname:String;

		/**
		 *
		 * @default
		 */
		public var title:String;

		/**
		 *
		 * @default
		 */
		public var url:String;

		/**
		 *
		 * @default
		 */
		public var workAddress:String;

		/**
		 *
		 * @default
		 */
		public var workCellNumber:String;

		/**
		 *
		 * @default
		 */
		public var workCity:String;

		/**
		 *
		 * @default
		 */
		public var workCountry:String;

		/**
		 *
		 * @default
		 */
		public var workFaxNumber:String;

		/**
		 *
		 * @default
		 */
		public var workPagerNumber:String;

		/**
		 *
		 * @default
		 */
		public var workPostalCode:String;

		/**
		 *
		 * @default
		 */
		public var workStateProvince:String;

		/**
		 *
		 * @default
		 */
		public var workVoiceNumber:String;

		/**
		 *
		 * @default
		 */
		private var _avatar:DisplayObject;

		/**
		 *
		 * @default
		 */
		private var _imageBytes:ByteArray;

		/**
		 *
		 * @default
		 */
		private var contact:RosterItemVO;

		/**
		 * Seems to be the way a vcard is requested and then later referred to:
		 * <code>var vCard:VCard = VCard.getVCard(_connection, item);<br />
		 * vCard.addEventListener(VCardEvent.LOADED, onVCard);</code>
		 * @param con
		 * @param user
		 * @return Reference to the VCard which will be filled once the loaded event occurs.
		 */
		public static function getVCard( con:XMPPConnection, user:RosterItemVO ):VCard
		{
			if ( !cacheFlushTimer.running )
			{
				cacheFlushTimer.start();
				cacheFlushTimer.addEventListener( TimerEvent.TIMER, function( event:TimerEvent ):void
					{
						var tempCache:Object = cache;
						cache = {};
						for each ( var cachedCard:VCard in tempCache )
						{
							pushRequest( con, vcard );
						}
					});
			}

			var jidString:String = user.jid.toString();

			var cachedCard:VCard = cache[ jidString ];
			if ( cachedCard )
				return cachedCard;

			var vcard:VCard = new VCard();
			vcard.contact = user;
			cache[ jidString ] = vcard;

			pushRequest( con, vcard );

			return vcard;
		}

		/**
		 *
		 * @param con
		 * @param vcard
		 */
		private static function pushRequest( con:XMPPConnection, vcard:VCard ):void
		{
			if ( !requestTimer )
			{
				requestTimer = new Timer( 1, 1 );
				requestTimer.addEventListener( TimerEvent.TIMER_COMPLETE, sendRequest );
			}
			requestQueue.push({ connection: con, card: vcard });
			requestTimer.reset();
			requestTimer.start();
		}

		/**
		 *
		 * @param event
		 */
		private static function sendRequest( event:TimerEvent ):void
		{
			if ( requestQueue.length == 0 )
				return;
			var req:Object = requestQueue.pop();
			var con:XMPPConnection = req.connection;
			var vcard:VCard = req.card;
			var user:RosterItemVO = vcard.contact;

			var iq:IQ = new IQ( user.jid.escaped, IQ.GET_TYPE );
			vcard.jid = user.jid;

			iq.callbackName = "handleVCard";
			iq.callbackScope = vcard;
			iq.addExtension( new VCardExtension());

			con.send( iq );
			requestTimer.reset();
			requestTimer.start();
		}

		/**
		 *
		 * @param resultIQ
		 */
		public function _vCardSent( resultIQ:IQ ):void
		{
			if ( resultIQ.type == IQ.ERROR_TYPE )
			{
				dispatchEvent( new VCardEvent( VCardEvent.ERROR, cache[ resultIQ.to.unescaped.toString()],
											   true, true ));
			}
			else
			{
				delete cache[ resultIQ.to.unescaped.toString()]; // Force profile refresh on next view
			}
		}

		/**
		 * Get the byte array to be used with a Loader.loadBytes or similar.
		 * @return Avatar bytes if any
		 */
		public function get avatar():ByteArray
		{
			return _imageBytes;
		}

		/**
		 *
		 * @param iq
		 */
		public function handleVCard( iq:IQ ):void
		{
			var node:XMLNode = iq.getNode();
			var vCardNode:XMLNode = node.childNodes[ 0 ];
			if ( !vCardNode )
				return;

			for each ( var child:XMLNode in vCardNode.childNodes )
			{
				switch ( child.nodeName )
				{
					case "PHOTO":
						for each ( var sChild:XMLNode in child.childNodes )
						{
							if ( sChild.nodeName != 'BINVAL' )
								continue;
							try
							{
								//sometimes we get a packet with just <BINVAL/> ... no idea why
								if ( sChild.childNodes.length == 0 )
									continue;
								var value:String = sChild.childNodes[ 0 ].nodeValue;
								if ( value.length > 0 )
								{
									var decoder:Base64Decoder = new Base64Decoder();
									decoder.decode( value );
									_imageBytes = decoder.flush();
									dispatchEvent( new VCardEvent( VCardEvent.AVATAR_LOADED,
																   this, true, false ));
								}
							}
							catch ( e:Error )
							{
								trace( "Error loading vcard image: " + e.message );
							}
						}
						break;

					case "N":
						// Get Family Name.
						var xml:XML = new XML( child.toString());
						firstName = xml.GIVEN;
						middleName = xml.MIDDLE;
						lastName = xml.FAMILY;
						break;

					case "FN":
						var fullnameNode:XMLNode = child.childNodes[ 0 ];
						if ( fullnameNode )
							fullName = fullnameNode.nodeValue;
						break;

					case "NICKNAME":
						var nicknameNode:XMLNode = child.childNodes[ 0 ];
						if ( nicknameNode )
							nickname = nicknameNode.nodeValue;
						break;

					case "EMAIL":
						for each ( var emailChild:XMLNode in child.childNodes )
						{
							if ( emailChild.nodeName == 'USERID' )
							{
								if ( emailChild.firstChild != null )
									email = emailChild.firstChild.nodeValue;
							}
						}
						break;
					case "ORG":
						var orgXML:XML = new XML( child.toString());
						company = orgXML.ORGNAME;
						department = orgXML.ORGUNIT;
						break;
					case "TITLE":
						var titleNode:XMLNode = child.childNodes[ 0 ];
						if ( titleNode )
							title = titleNode.nodeValue;
						break;
					case "URL":
						var urlNode:XMLNode = child.childNodes[ 0 ];
						if ( urlNode )
							url = urlNode.nodeValue;
						break;
					case "ADR":
						var adrXML:XML = new XML( child.toString());
						if ( adrXML.WORK == '' )
						{
							workPostalCode = adrXML.PCODE;
							workStateProvince = adrXML.REGION;
							workAddress = adrXML.STREET;
							workCountry = adrXML.CTRY;
							workCity = adrXML.LOCALITY;
						}
						else if ( adrXML.HOME == '' )
						{
							homePostalCode = adrXML.PCODE;
							homeStateProvince = adrXML.REGION;
							homeAddress = adrXML.STREET;
							homeCountry = adrXML.CTRY;
							homeCity = adrXML.LOCALITY;
						}
						break;
					case "TEL":
						var telXML:XML = new XML( child.toString());
						if ( telXML.WORK == '' )
						{
							if ( telXML.VOICE == '' )
								workVoiceNumber = telXML.NUMBER;
							else if ( telXML.FAX == '' )
								workFaxNumber = telXML.NUMBER;
							else if ( telXML.PAGER == '' )
								workPagerNumber = telXML.NUMBER;
							else if ( telXML.CELL == '' )
								workCellNumber = telXML.NUMBER;
						}
						else if ( telXML.HOME == '' )
						{
							if ( telXML.VOICE == '' )
								homeVoiceNumber = telXML.NUMBER;
							else if ( telXML.FAX == '' )
								homeFaxNumber = telXML.NUMBER;
							else if ( telXML.PAGER == '' )
								homePagerNumber = telXML.NUMBER;
							else if ( telXML.CELL == '' )
								homeCellNumber = telXML.NUMBER;
						}
						break;
				}
			}

			loaded = true;
			dispatchEvent( new VCardEvent( VCardEvent.LOADED, this, true, false ));
		}

		/**
		 *
		 * @param con
		 * @param user
		 */
		public function saveVCard( con:XMPPConnection, user:RosterItemVO ):void
		{
			var iq:IQ = new IQ( null, IQ.SET_TYPE, XMPPStanza.generateID( "save_vcard_" ),
								null, this, _vCardSent );
			var vcardExt:VCardExtension = new VCardExtension();
			var vcardExtNode:XMLNode = vcardExt.getNode();

			if ( firstName || middleName || lastName )
			{
				var nameNode:XMLNode = new XMLNode( 1, 'N' );

				if ( firstName )
				{
					var firstNameNode:XMLNode = new XMLNode( 1, 'GIVEN' );
					firstNameNode.appendChild( new XMLNode( 3, firstName ));

					nameNode.appendChild( firstNameNode );
				}

				if ( middleName )
				{
					var middleNameNode:XMLNode = new XMLNode( 1, 'MIDDLE' );
					middleNameNode.appendChild( new XMLNode( 3, middleName ));

					nameNode.appendChild( middleNameNode );
				}

				if ( lastName )
				{
					var lastNameNode:XMLNode = new XMLNode( 1, 'FAMILY' );
					lastNameNode.appendChild( new XMLNode( 3, lastName ));

					nameNode.appendChild( lastNameNode );
				}

				vcardExtNode.appendChild( nameNode );
			}

			if ( fullName )
			{
				var fullnameNode:XMLNode = new XMLNode( 1, 'FN' );
				fullnameNode.appendChild( new XMLNode( 3, fullName ));

				vcardExtNode.appendChild( fullnameNode );
			}

			if ( nickname )
			{
				var nicknameNode:XMLNode = new XMLNode( 1, 'NICKNAME' );
				nicknameNode.appendChild( new XMLNode( 3, nickname ));

				vcardExtNode.appendChild( nicknameNode );
			}

			if ( email )
			{
				var emailNode:XMLNode = new XMLNode( 1, 'EMAIL' );
				emailNode.appendChild( new XMLNode( 3, 'INTERNET' ));
				emailNode.appendChild( new XMLNode( 3, 'PREF' ));
				var userIdNode:XMLNode = new XMLNode( 1, 'USERID' );
				userIdNode.appendChild( new XMLNode( 3, email ));
				emailNode.appendChild( userIdNode );

				vcardExtNode.appendChild( emailNode );
			}

			if ( company || department )
			{
				var organizationNode:XMLNode = new XMLNode( 1, 'ORG' );

				if ( company )
				{
					var companyNode:XMLNode = new XMLNode( 1, 'ORGNAME' );
					companyNode.appendChild( new XMLNode( 3, company ));

					organizationNode.appendChild( companyNode );
				}

				if ( department )
				{
					var departmentNode:XMLNode = new XMLNode( 1, 'ORGUNIT' );
					departmentNode.appendChild( new XMLNode( 3, department ));

					organizationNode.appendChild( departmentNode );
				}

				vcardExtNode.appendChild( organizationNode );
			}

			if ( title )
			{
				var titleNode:XMLNode = new XMLNode( 1, 'TITLE' );
				titleNode.appendChild( new XMLNode( 3, title ));

				vcardExtNode.appendChild( titleNode );
			}

			if ( url )
			{
				var urlNode:XMLNode = new XMLNode( 1, 'URL' );
				urlNode.appendChild( new XMLNode( 3, url ));

				vcardExtNode.appendChild( urlNode );
			}

			if ( workAddress || workCity || workCountry || workPostalCode || workStateProvince )
			{
				var workAddressNode:XMLNode = new XMLNode( 1, 'ADR' );
				workAddressNode.appendChild( new XMLNode( 1, 'WORK' ));

				if ( workAddress )
				{
					var workStreetNode:XMLNode = new XMLNode( 1, 'STREET' );
					workStreetNode.appendChild( new XMLNode( 3, workAddress ));

					workAddressNode.appendChild( workStreetNode );
				}

				if ( workCity )
				{
					var workCityNode:XMLNode = new XMLNode( 1, 'LOCALITY' );
					workCityNode.appendChild( new XMLNode( 3, workCity ));

					workAddressNode.appendChild( workCityNode );
				}

				if ( workCountry )
				{
					var workCountryNode:XMLNode = new XMLNode( 1, 'CTRY' );
					workCountryNode.appendChild( new XMLNode( 3, workCountry ));

					workAddressNode.appendChild( workCountryNode );
				}

				if ( workPostalCode )
				{
					var workPostalCodeNode:XMLNode = new XMLNode( 1, 'PCODE' );
					workPostalCodeNode.appendChild( new XMLNode( 3, workPostalCode ));

					workAddressNode.appendChild( workPostalCodeNode );
				}

				if ( workStateProvince )
				{
					var workStateProvinceNode:XMLNode = new XMLNode( 1, 'REGION' );
					workStateProvinceNode.appendChild( new XMLNode( 3, workStateProvince ));

					workAddressNode.appendChild( workStateProvinceNode );
				}

				vcardExtNode.appendChild( workAddressNode );
			}

			if ( homeAddress || homeCity || homeCountry || homePostalCode || homeStateProvince )
			{
				var homeAddressNode:XMLNode = new XMLNode( 1, 'ADR' );
				homeAddressNode.appendChild( new XMLNode( 1, 'HOME' ));

				if ( homeAddress )
				{
					var homeStreetNode:XMLNode = new XMLNode( 1, 'STREET' );
					homeStreetNode.appendChild( new XMLNode( 3, homeAddress ));

					homeAddressNode.appendChild( homeStreetNode );
				}

				if ( homeCity )
				{
					var homeCityNode:XMLNode = new XMLNode( 1, 'LOCALITY' );
					homeCityNode.appendChild( new XMLNode( 3, homeCity ));

					homeAddressNode.appendChild( homeCityNode );
				}

				if ( homeCountry )
				{
					var homeCountryNode:XMLNode = new XMLNode( 1, 'CTRY' );
					homeCountryNode.appendChild( new XMLNode( 3, homeCountry ));

					homeAddressNode.appendChild( homeCountryNode );
				}

				if ( homePostalCode )
				{
					var homePostalCodeNode:XMLNode = new XMLNode( 1, 'PCODE' );
					homePostalCodeNode.appendChild( new XMLNode( 3, homePostalCode ));

					homeAddressNode.appendChild( homePostalCodeNode );
				}

				if ( homeStateProvince )
				{
					var homeStateProvinceNode:XMLNode = new XMLNode( 1, 'REGION' );
					homeStateProvinceNode.appendChild( new XMLNode( 3, homeStateProvince ));

					homeAddressNode.appendChild( homeStateProvinceNode );
				}

				vcardExtNode.appendChild( homeAddressNode );
			}

			if ( workCellNumber )
			{
				var workCellNode:XMLNode = new XMLNode( 1, 'TEL' );
				workCellNode.appendChild( new XMLNode( 1, 'WORK' ));
				workCellNode.appendChild( new XMLNode( 1, 'CELL' ));
				var workCellNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				workCellNumberNode.appendChild( new XMLNode( 3, workCellNumber ));
				workCellNode.appendChild( workCellNumberNode );

				vcardExtNode.appendChild( workCellNode );
			}

			if ( workFaxNumber )
			{
				var workFaxNode:XMLNode = new XMLNode( 1, 'TEL' );
				workFaxNode.appendChild( new XMLNode( 1, 'WORK' ));
				workFaxNode.appendChild( new XMLNode( 1, 'FAX' ));
				var workFaxNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				workFaxNumberNode.appendChild( new XMLNode( 3, workFaxNumber ));
				workFaxNode.appendChild( workFaxNumberNode );

				vcardExtNode.appendChild( workFaxNode );
			}

			if ( workPagerNumber )
			{
				var workPagerNode:XMLNode = new XMLNode( 1, 'TEL' );
				workPagerNode.appendChild( new XMLNode( 1, 'WORK' ));
				workPagerNode.appendChild( new XMLNode( 1, 'PAGER' ));
				var workPagerNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				workPagerNumberNode.appendChild( new XMLNode( 3, workPagerNumber ));
				workPagerNode.appendChild( workPagerNumberNode );

				vcardExtNode.appendChild( workPagerNode );
			}

			if ( workVoiceNumber )
			{
				var workVoiceNode:XMLNode = new XMLNode( 1, 'TEL' );
				workVoiceNode.appendChild( new XMLNode( 1, 'WORK' ));
				workVoiceNode.appendChild( new XMLNode( 1, 'VOICE' ));
				var workVoiceNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				workVoiceNumberNode.appendChild( new XMLNode( 3, workVoiceNumber ));
				workVoiceNode.appendChild( workVoiceNumberNode );

				vcardExtNode.appendChild( workVoiceNode );

			}

			if ( homeCellNumber )
			{
				var homeCellNode:XMLNode = new XMLNode( 1, 'TEL' );
				homeCellNode.appendChild( new XMLNode( 1, 'HOME' ));
				homeCellNode.appendChild( new XMLNode( 1, 'CELL' ));
				var homeCellNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				homeCellNumberNode.appendChild( new XMLNode( 3, homeCellNumber ));
				homeCellNode.appendChild( homeCellNumberNode );

				vcardExtNode.appendChild( homeCellNode );
			}

			if ( homeFaxNumber )
			{
				var homeFaxNode:XMLNode = new XMLNode( 1, 'TEL' );
				homeFaxNode.appendChild( new XMLNode( 1, 'HOME' ));
				homeFaxNode.appendChild( new XMLNode( 1, 'FAX' ));
				var homeFaxNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				homeFaxNumberNode.appendChild( new XMLNode( 3, homeFaxNumber ));
				homeFaxNode.appendChild( homeFaxNumberNode );

				vcardExtNode.appendChild( homeFaxNode );
			}

			if ( homePagerNumber )
			{
				var homePagerNode:XMLNode = new XMLNode( 1, 'TEL' );
				homePagerNode.appendChild( new XMLNode( 1, 'HOME' ));
				homePagerNode.appendChild( new XMLNode( 1, 'PAGER' ));
				var homePagerNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				homePagerNumberNode.appendChild( new XMLNode( 3, homePagerNumber ));
				homePagerNode.appendChild( homePagerNumberNode );

				vcardExtNode.appendChild( homePagerNode );
			}

			if ( homeVoiceNumber )
			{
				var homeVoiceNode:XMLNode = new XMLNode( 1, 'TEL' );
				homeVoiceNode.appendChild( new XMLNode( 1, 'HOME' ));
				homeVoiceNode.appendChild( new XMLNode( 1, 'VOICE' ));
				var homeVoiceNumberNode:XMLNode = new XMLNode( 1, 'NUMBER' );
				homeVoiceNumberNode.appendChild( new XMLNode( 3, homeVoiceNumber ));
				homeVoiceNode.appendChild( homeVoiceNumberNode );

				vcardExtNode.appendChild( homeVoiceNode );
			}

			iq.addExtension( vcardExt );
			con.send( iq );
		}
	}
}
