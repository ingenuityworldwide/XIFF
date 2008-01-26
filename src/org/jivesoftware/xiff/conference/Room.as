﻿/*
 * Copyright (C) 2003-2007
 * Nick Velloff <nick.velloff@gmail.com>
 * Derrick Grigg <dgrigg@rogers.com>
 * Sean Voisen <sean@voisen.org>
 * Sean Treadway <seant@oncotype.dk>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 *
 */
 
package org.jivesoftware.xiff.conference
{
	import mx.collections.ArrayCollection;
	
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.data.*;
	import org.jivesoftware.xiff.data.forms.FormExtension;
	import org.jivesoftware.xiff.data.muc.*;
	import org.jivesoftware.xiff.events.DisconnectionEvent;
	import org.jivesoftware.xiff.events.MessageEvent;
	import org.jivesoftware.xiff.events.PresenceEvent;
	import org.jivesoftware.xiff.events.RoomEvent;
	
	/**
	 * Dispatched when the room subject changes.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent.SUBJECT_CHANGE
	 */
	[Event( name="subjectChange", type="org.jivesoftware.xiff.events.RoomEvent" )]
	
	/**
	 * Dispatched whenever a new message intented for all room occupants is received. The 
	 * <code>RoomEvent</code> class will contain an attribute <code>data</code> with the 
	 * group message as an instance of the <code>Message</code> class.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event( name="groupMessage", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched whenever a new private message is received. The <code>RoomEvent</code> class
	 * contains an attribute <code>data</code> with the private message as an instance of the 
	 * <code>Message</code> class.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="privateMessage", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when you have entered the room and messages that are sent
	 * will be displayed to other users. The room's role and affiliation will
	 * be visible from this point forward.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="roomJoin", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when the server acknoledges that you have the left the room.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="roomLeave", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when an affiliation list has been requested. The event object contains an 
	 * array of <code>MUCItems</code> containing the JID and affiliation properties.
	 *
	 * <p>To grant or revoke permissions based on this list, only send the changes you wish to 
	 * make, calling grant/revoke with the new affiliation and existing JID.</p>
	 * 
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="affiliations", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when an administration action failed.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 * @see org.jivesoftware.xiff.core.XMPPConnection.error
	 */
	[Event(name="adminError", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when the room requires a password and the user did not supply one (or
	 * the password provided is incorrect).
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="passwordError", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when the room is members-only and the user is not on the member list.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="registrationReqError", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched if the user attempted to join the room but was not allowed to do so because
	 * they are banned (i.e., has an affiliation of "outcast").
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="bannedError", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched if the room has reached its maximum number of occupants.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="maxUsersError", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched if a user attempts to enter a room while it is "locked" (i.e., before the room
	 * creator provides an initial configuration and therefore before the room officially exists).
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="lockedError", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched whenever an occupant joins the room. The <code>RoomEvent</code> instance will 
	 * contain an attribute <code>nickname</code> with the nickname of the occupant who joined.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="userJoin", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched whenever an occpant leaves the room. The <code>RoomEvent</code> instance will
	 * contain an attribute <code>nickname</code> with the nickname of the occupant who left.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="userDeparture", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when a user is kicked from the room.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="userKicked", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when a user is banned from the room.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="userBanned", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when the user's preferred nickname already exists in the room.  The 
	 * <code>RoomEvent</code> will contain an attribute <code>nickname</code> with the nickname 
	 * already existing in the room.
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="nickConflict", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when a room configuration form is required.  This can occur during the 
	 * creation of a room, or if a room configuration is requested.  The <code>RoomEvent</code>
	 * instance will contain an attribute <code>data</code> that is an instance of an object 
	 * with the following attributes:
	 * 
	 * <p><code>instructions</code>: Instructions for the use of form<br />
	 * <code>title</code>: Title of the configuration form<br />
	 * <code>label</code>: A friendly name for the field<br />
	 * <code>name</code>: A computer readable identifier for the field used to identify 
	 * this field in the result passed to <code>configure()</code><br />
	 * <code>type</code>: The type of the field to be displayed. Type will be a constant
	 * from the <code>FormField</code> class.</p>
	 * 
	 * @see org.jivesoftware.xiff.data.forms.FormExtension
	 * @see org.jivesoftware.xiff.data.forms.FormField
	 * @see #configure
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="configureForm", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Dispatched when an invite to this room has been declined by the invitee. The <code>RoomEvent</code>
	 * <code>data</code> property that has the following attributes:
	 *
	 * <p><code>from</code>: The JID of the user initiating the invite<br />
	 * <code>reason</code>: A string containing the reason to join the room<br />
	 * <code>data</code>: The original message containing the decline</p>
	 *
	 * @eventType org.jivesoftware.xiff.events.RoomEvent
	 */
	[Event(name="declined", type="org.jivesoftware.xiff.events.RoomEvent")]
	
	/**
	 * Manages incoming and outgoing data from a conference room as part of multi-user conferencing (JEP-0045).
	 * You will need an instance of this class for each room that the user joins.
	 *
	 * @param connection An XMPPConnection instance that is providing the primary server connection
	 */
	public class Room extends ArrayCollection
	{
		public static const NO_AFFILIATION:String = MUC.NO_AFFILIATION;
		public static const MEMBER_AFFILIATION:String = MUC.MEMBER_AFFILIATION;
		public static const ADMIN_AFFILIATION:String = MUC.ADMIN_AFFILIATION;
		public static const OWNER_AFFILIATION:String = MUC.OWNER_AFFILIATION;
		public static const OUTCAST_AFFILIATION:String = MUC.OUTCAST_AFFILIATION;
		
		public static const NO_ROLE:String = MUC.NO_ROLE;
		public static const MODERATOR_ROLE:String = MUC.MODERATOR_ROLE;
		public static const PARTICIPANT_ROLE:String = MUC.PARTICIPANT_ROLE;
		public static const VISITOR_ROLE:String = MUC.VISITOR_ROLE;
	
		private var myConnection:XMPPConnection;
	    private var myJID:String;
		private var myNickname:String;
	    private var myPassword:String;
		private var myRole:String;
		private var myAffiliation:String;
	    private var myIsReserved:Boolean;
	    private var mySubject:String;
		
		private var active:Boolean;
		
		// Used to store nicknames in pending status, awaiting change approval from server
		private var pendingNickname:String;

		private static var staticConstructorDependencies:Array = [ 
	        FormExtension,
	        MUC
		]
	
		private static var roomStaticConstructed:Boolean = RoomStaticConstructor();
		
		public function Room( aConnection:XMPPConnection=null )
		{
			active = false;
			if (aConnection != null){
				setConnection( aConnection );
			}
		}
		
		private static function RoomStaticConstructor():Boolean
		{
	        MUC.enable();
	        FormExtension.enable();
			
			return true;
		}
		
		/**
		 * Sets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @param connection The XMPPConnection instance to use.
		 * @see org.jivesoftware.xiff.core.XMPPConnection
		 */
		public function setConnection( connection:XMPPConnection ):void
		{
			if (myConnection != null)
			{
				myConnection.removeEventListener(MessageEvent.MESSAGE, handleEvent);
				myConnection.removeEventListener(PresenceEvent.PRESENCE, handleEvent);
				myConnection.removeEventListener(DisconnectionEvent.DISCONNECT, handleEvent);	
			}
			
			
			myConnection = connection;
			
			myConnection.addEventListener(MessageEvent.MESSAGE, handleEvent, false, 0, true);
			myConnection.addEventListener(PresenceEvent.PRESENCE, handleEvent, false, 0, true);
			myConnection.addEventListener(DisconnectionEvent.DISCONNECT, handleEvent, false, 0, true);
		}
	
		/**
		 * Gets a reference to the XMPPConnection being used for incoming/outgoing XMPP data.
		 *
		 * @returns The XMPPConnection used
		 * @see org.jivesoftware.xiff.core.XMPPConnection
		 */
		public function getConnection():XMPPConnection
		{
			return myConnection;
		}
		 
	    /** 
	     * Joins a conference room based on the parameters specified by the room
	     * properties.  This call will create an instant room based on a default
	     * server configuration if the room doesn't exist.  
	     * 
	     * <p>To create and begin the configuration process of a reserved room, pass
	     * <code>true</code> to this method to begin the configuration process.  When
	     * The configuration is complete, the room will be unlocked for others to join.
	     * Listen for the <code>RoomEvent.CONFIGURE_ROOM</code> event to handle and 
	     * either return or cancel the configuration of the room.
		 *
	     * @param createReserved Set to true if you wish to create and configure a reserved room
		 * @return A boolean indicating whether the join attempt was successfully sent.
		 */
		public function join( createReserved:Boolean = false, joinPresenceExtensions:Array = null ):Boolean
		{
			if(!myConnection.isActive() || isActive()) {
				return false;
			}
			
			myIsReserved = createReserved == true ? true : false;

			var joinPresence:Presence = new Presence( getUserJID() );
			if (joinPresenceExtensions != null) {
				for (var i:int = 0; i < joinPresenceExtensions.length; i++) {
					joinPresence.addExtension(joinPresenceExtensions[i]);
				}
			}

			var muc:MUCExtension = new MUCExtension();
	        
	        if( password != null ) {
	        	muc.password = password;
	        }
	
			joinPresence.addExtension(muc);
			myConnection.send( joinPresence );
			return true;
		}
		 
		/**
		 * Leaves the current conference room, assuming that the user has joined one.
		 * If the user is not currently in a room, this method does nothing.
		 */
		public function leave():void
		{
			if( isActive() ) {
				var leavePresence:Presence = new Presence( getUserJID(), null, Presence.UNAVAILABLE_TYPE );
				myConnection.send( leavePresence );
				
				// Clear out the roster items
				removeAll();
				myConnection.removeEventListener(MessageEvent.MESSAGE, handleEvent);
				myConnection.removeEventListener(DisconnectionEvent.DISCONNECT, handleEvent);
			}
		}
		
		/**
		 * Gets an instance of the <code>Message</code> class that has been pre-configured to be 
		 * sent from this room. Use this method to get a <code>Message</code> in order to add extensions 
		 * to outgoing room messages.
		 * 
		 * @param body The message body
		 * @param htmlBody The message body with HTML formatting
		 * @return A <code>Message</code> class instance
		 */
		public function getMessage( body:String = null, htmlBody:String = null ):Message
		{
			var tempMessage:Message = new Message( getRoomJID(), null, body, htmlBody, Message.GROUPCHAT_TYPE );
			return tempMessage;
		}
		
		/**
		 * Sends a message to the conference room.
		 *
		 * @param body The message body
		 * @param htmlBody The message body with HTML formatting
		 */
		public function sendMessage( body:String=null, htmlBody:String=null ):void
		{
			if( isActive() ) {
				var tempMessage:Message = new Message( getRoomJID(), null, body, htmlBody, Message.GROUPCHAT_TYPE );
				myConnection.send( tempMessage );
			}
		}
		
		/**
		 * Sends a message to the conference room with an extension attached. 
		 * Use this method in conjunction with the <code>getMessage</code> method.
		 *
		 * @param msg The message to send
		 */
		public function sendMessageWithExtension( msg:Message ):void
		{
			if( isActive() ) {
				myConnection.send( msg );
			}
		}
		
		/**
		 * Sends a private message to a specific participant in the conference room.
		 *
		 * @param recipientNickname The conference room nickname of the recipient who should 
		 * receive the private message
		 * @param body The message body
		 * @param htmlBody The message body with HTML formatting
		 */
		public function sendPrivateMessage( recipientNickname:String, body:String = null, htmlBody:String = null ):void
		{
			if( isActive() ) {
				var tempMessage:Message = new Message( getRoomJID() + "/" + recipientNickname, null, body, htmlBody, Message.CHAT_TYPE );
				myConnection.send( tempMessage );
			}
		}
		
		/**
		 * Changes the subject in the conference room. You must have already joined the 
		 * room before you can change the subject.
		 *
		 * @param newSubject The new subject
		 */
		public function changeSubject( newSubject:String ):void
		{
			if( isActive() ) {
				var tempMessage:Message = new Message( getRoomJID(), null, null, null, Message.GROUPCHAT_TYPE, newSubject );
				myConnection.send( tempMessage );
			}
		}
		
		/**
		 * Kicks an occupant out of the room, assuming that the user has necessary 
		 * permissions in order to do so. If the user does not, the server will return an error.
		 *
		 * @param occupantNick The nickname of the room occupant to kick
		 * @param reason The reason for the kick
		 */
		public function kickOccupant( occupantNick:String, reason:String ):void
		{
			if( isActive() ) {
				var tempIQ:IQ = new IQ( getRoomJID(), IQ.SET_TYPE, XMPPStanza.generateID("kick_occupant_") );
				var ext:MUCAdminExtension = new MUCAdminExtension(tempIQ.getNode());
				//ext.addItem(null, MUC.NO_ROLE, null, null, null, reason);
				ext.addItem(null, MUC.NO_ROLE, occupantNick, null, null, reason); 
				tempIQ.addExtension(ext);
				myConnection.send( tempIQ );
			}
		}
		
		/**
		 * In a moderated room, sets voice status to a particular occupant, assuming the user 
		 * has the necessary permissions to do so.
		 *
		 * @param occupantNick The nickname of the occupant to give voice
		 * @param voice Whether to add voice (true) or remove voice (false). Having voice means
		 * that the user is actually able to talk. Without voice the user is effectively muted.
		 */
		public function setOccupantVoice( occupantNick:String, voice:Boolean ):void
		{
			if( isActive() ) {
				var tempIQ:IQ = new IQ( getRoomJID(), IQ.SET_TYPE, XMPPStanza.generateID("voice_") );
				var ext:MUCAdminExtension = new MUCAdminExtension(tempIQ.getNode());
				ext.addItem(null, voice ? MUC.PARTICIPANT_ROLE : MUC.VISITOR_ROLE);
				tempIQ.addExtension(ext);
				myConnection.send( tempIQ );
			}
		}
	
	    /**
	     * Invites a user that is not currently a member of this room to this room.
	     *
	     * <p>You must have joined the room and have appropriate permissions to invite 
	     * other memebers, because the server will format and send the invite message to 
	     * as if it came from the room rather that you sending the invite directly from you.</p>
	     *
	     * <p>To listen to invite events, add an event listener on your XMPPConnection to the
	     * <code>InviteEvent.INVITED</code> event.</p>
	     *
	     * @param jid A string JID of the user to invite.
	     * @param reason A string describing why you would like to invite the user.
	     */
	    public function invite( jid:String, reason:String ):void
	    {
	        var msg:Message = new Message(getRoomJID())
	        var muc:MUCUserExtension = new MUCUserExtension();
	
	        muc.invite(jid, undefined, reason);
	
	        msg.addExtension(muc);
	        myConnection.send(msg);
	    }
	
	    /**
	     * Actively decline an invitation.  You can optionally ignore invitations
	     * but if you choose to decline an invitation, you call this method on
	     * a room instance that represents the room the invite originated from.
	     *
	     * <p>You do not need to have joined this room to decline an invitation</p>
	     *
	     * <p>Note: mu-conference-0.6 does not allow users to send decline
	     * messages without joining first.  If using this version of conferencing
	     * software, it is best to ignore invites.</p>
	     *
	     * @param reason A string describing why the invitiation was declined
	     */
	    public function decline(jid:String, reason:String):void
	    {
	        var msg:Message = new Message(getRoomJID())
	        var muc:MUCUserExtension = new MUCUserExtension();
	
	        muc.decline(jid, undefined, reason);
	
	        msg.addExtension(muc);
	        myConnection.send(msg);
	    }
	
		/**
		 * <strong>DEPRECATED! Use <code>getRoomJID</code> instead.</strong>
		 * Gets the fully qualified room name (room@server) of the current room.
		 *
		 * @return The fully qualified room name.
		 */
		public function getFullRoomName():String
		{
	        return getRoomJID();
		}
	
	    /**
	     * Get the JID of the room.
	     *
	     * @return The room's JID.
	     */
	    public function getRoomJID():String
	    {
	        return myJID;
	    }
		
	    /**
	     * Set the JID of the room in the form "room@conference.server"
	     */
	    public function setRoomJID( jid:String ):void
	    {
	        myJID = jid;
	    }
		
	    /**
	     * Get the JID of the conference room user.
	     *
	     * @return your JID in the room 
	     */
	    public function getUserJID():String
	    {
	        return getRoomJID() + "/" + nickname;
	    }
		
		/**
		 * Gets the user's role in the conference room. 
		 * Possible roles are "visitor", "participant", "moderator" or no defined role.
		 *
		 * @return The user's role
		 */
		public function getRole():String
		{
			return myRole;
		}
		
		/**
		 * Gets the user's affiliation for this room.
		 * Possible affiliations are "owner", "admin", "member", and "outcast". 
		 * It is also possible to have no defined affiliation.
		 *
		 * @return The user's affiliation
		 */
		public function getAffiliation():String
		{
			return myAffiliation;
		}
	
		/**
		 * Determines whether the connection to the room is active - that is, the user 
		 * is connected and has joined the room.
		 *
		 * @return True if the connection is active; false otherwise.
		 */
		public function isActive():Boolean
		{
			return active;
		}

		private function handleEvent( eventObj:Object ):void
		{
			switch( eventObj.type )
			{
				case "message":
					var msg:Message = eventObj.data;
					
					// Check to see that the message is from this room
					if( isThisRoom( msg.from ) ) {
						var e:RoomEvent;
						if ( msg.type == Message.GROUPCHAT_TYPE ) {
							// Check for a subject change
							if( msg.subject != null ) {
								mySubject = msg.subject;
								e = new RoomEvent(RoomEvent.SUBJECT_CHANGE);
								e.subject = msg.subject;
								dispatchEvent(e);
							}
							else {
								e = new RoomEvent(RoomEvent.GROUP_MESSAGE);
								e.data = msg;
								dispatchEvent(e);
							}
						} else if ( msg.type == Message.NORMAL_TYPE ) {
								var form:Array = msg.getAllExtensionsByNS(FormExtension.NS)[0];
								if (form) {
									e = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
									e.data = form;
									dispatchEvent(e);
								}

						}
					}
	
					// It could be a private message via the conference
					else if( isThisUser(msg.to) && msg.type == Message.CHAT_TYPE ) {
						e = new RoomEvent(RoomEvent.PRIVATE_MESSAGE);
						e.data = msg;
						dispatchEvent(e);
	                } 
	                
	                // Could be an decline to a previous invite
	                else {
	                	var mucExtensions:Array = msg.getAllExtensionsByNS(MUCUserExtension.NS);
	                	if (mucExtensions != null && mucExtensions.length > 0) {
	                		var muc:MUCUserExtension = mucExtensions[0];
		                	if (muc && muc.type == MUCUserExtension.DECLINE_TYPE) 
		                	{
		                    	e = new RoomEvent(RoomEvent.DECLINED);
		                    	e.from = muc.reason;
		                    	e.reason = muc.reason;
		                    	e.data = msg;
		                    	dispatchEvent(e);
		                    }
		                }
	                }
					break;
					
				case "presence":
	                //trace("ROOM presence: " + presence.from + " : " + nickname);
					for each(var presence:Presence in eventObj.data)
					{
						if (presence.type == Presence.ERROR_TYPE) 
						{
							switch (presence.errorCode) 
							{
								case 401:
									e = new RoomEvent(RoomEvent.PASSWORD_ERROR);
									break;
								
								case 403:
									e = new RoomEvent(RoomEvent.BANNED_ERROR);
									break;
								
								case 404:
									e = new RoomEvent(RoomEvent.LOCKED_ERROR);
									break;
									
								case 407:
									e = new RoomEvent(RoomEvent.REGISTRATION_REQ_ERROR);
									break;
								
								case 409:
									e = new RoomEvent(RoomEvent.NICK_CONFLICT);
									e.nickname = nickname;
									break;
								
								case 503:
									e = new RoomEvent(RoomEvent.MAX_USERS_ERROR);
									break;
									
								default:
									e = new RoomEvent("MUC Error of type: " + presence.errorCode);
									break;
							}
							dispatchEvent(e);
						}
						else if( isThisRoom( presence.from ) ) 
						{
							// If the presence has our pending nickname, nickname change went through
							if( presence.from.split( "/" )[1] == pendingNickname ) 
							{
								myNickname = pendingNickname;
								pendingNickname = null;
							}
							
							var user:MUCUserExtension = presence.getAllExtensionsByNS(MUCUserExtension.NS)[0];
							switch (user.statusCode) 
							{
								case 201:
									unlockRoom(myIsReserved);
									break;
								case 307:
									e = new RoomEvent(RoomEvent.USER_KICKED);
									e.nickname = new JID(presence.from).resource;
									dispatchEvent(e);
									break;
								case 301:
									e = new RoomEvent(RoomEvent.USER_BANNED);
									e.nickname = new JID(presence.from).resource;
									dispatchEvent(e);
									break;
							}
	
							updateRoomRoster( presence );
		
							if (presence.type == Presence.UNAVAILABLE_TYPE && isActive() && isThisUser(presence.from)) {
								//trace("Room: becoming inactive: " + presence.getNode());
								active = false;
								e = new RoomEvent(RoomEvent.ROOM_LEAVE);
								dispatchEvent(e);
								myConnection.removeEventListener(PresenceEvent.PRESENCE, handleEvent);
							}
						}
					}
					break;
	
					
				case "disconnection":
					// The server disconnected, so we are no longer active
					active = false;
					removeAll();
					e = new RoomEvent(RoomEvent.ROOM_LEAVE);
					dispatchEvent(e);
					break;
			}
		}
	
	    /*
	     * Room owner (creation/configuration/destruction) methods
	     */
	
	    private function unlockRoom( isReserved:Boolean ):void
	    {
	        // http://www.jabber.org/jeps/jep-0045.html#createroom
	
	        if( isReserved ) {
	            requestConfiguration();
	        } else {
	            // Send an empty configuration form to open the instant room
	
	            // The IQ.result for this request will signify that the room is
	            // unlocked.  Sometimes there are messages that are sent before
	            // the request is returned.  It may be smart to either block those
	            // messages, or provide 2 events "beginConfiguration" and "endConfiguration"
	            // so the application can decide to block configuration messages
	
	            var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	            var owner:MUCOwnerExtension = new MUCOwnerExtension();
	            var form:FormExtension = new FormExtension();
	
	            form.type = FormExtension.SUBMIT_TYPE;
	
	            owner.addExtension(form);
	            iq.addExtension(owner);
	            myConnection.send(iq);
	        }
	    }
	
		/**
		 * Requests a configuration form from the room.  Listen to <code>configureForm</code>
	     * event to fill out the form then call either <code>configure</code> or
	     * <code>cancelConfiguration</code> to complete the configuration process
	     *
	     * You must be joined to the room and have the owner affiliation to request 
	     * a configuration form
		 *
	     * @see #configureForm
	     * @see #configure
	     * @see #cancelConfiguration
		 */
	    public function requestConfiguration():void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.GET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callbackScope = this;
	        iq.callbackName = "finish_requestConfiguration";
	        iq.addExtension(owner);
	
	        myConnection.send(iq);
	    }
	
	    /**
	     * @private
	     *  
	     * IQ callback when form is ready
	     */
	    public function finish_requestConfiguration(iq:IQ):void
	    {
			if( iq.type == IQ.ERROR_TYPE ) {
				finish_admin(iq);
				return;
			}
	
			var owner:MUCOwnerExtension = iq.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
	        var form:FormExtension = owner.getAllExtensionsByNS(FormExtension.NS)[0];
	
	        if( form.type == FormExtension.REQUEST_TYPE ) {
	        	var e:RoomEvent = new RoomEvent(RoomEvent.CONFIGURE_ROOM);
	        	e.data = form;
	        	dispatchEvent(e);
	        }
	    }
	
		/**
		 * Sends a configuration form to the room.
	     *
	     * You must be joined and have owner affiliation to configure the room
	     *
	     * @param fieldmap A hash that is an object with keys being the room configuration
	     * form variables and the values being arrays. For single value fields, use a single 
	     * element array.
	     * @see #configureForm
		 */
	    public function configure(fieldmap:Object):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
			var form:FormExtension;
	
			if (fieldmap is FormExtension) {
				form = FormExtension(fieldmap);
			} else {
				form = new FormExtension();
				fieldmap["FORM_TYPE"] = [MUCOwnerExtension.NS];
				form.setFields(fieldmap);
			}
			form.type = FormExtension.SUBMIT_TYPE;
			owner.addExtension(form);
	
	        iq.addExtension(owner);
	        myConnection.send(iq);
	    }
	
		/**
		 * Cancels the configuration process.  The room may still be locked if
	     * you cancel the configuration process when attempting to join a
	     * reserved room.
	     *
	     * <p>You must have joined the room and have the owner affiliation to 
	     * configure the room.</p>
	     *
	     * @see #configureForm
	     * @see #join
		 */
	    public function cancelConfiguration():void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	        var form:FormExtension = new FormExtension();
	
	        form.type = FormExtension.CANCEL_TYPE;
	
	        owner.addExtension(form);
	        iq.addExtension(owner);
	        myConnection.send(iq);
	    }
	
	    /**
	     * Grants permissions on a room one or more JIDs by setting the 
	     * affiliation of a user based * on their JID.
	     *
	     * <p>If the JID currenly has an existing affiliation, then the existing 
	     * affiliation will be replaced with the one passed. If the process could not be 
	     * completed, the room will dispatch the event <code>RoomEvent.ADMIN_ERROR</code>.
	     * 
	     * @param affiliation Use one of the 
	     * following affiliations: <code>Room.MEMBER_AFFILIATION</code>,
	     * <code>Room.ADMIN_AFFILIATION</code>,
	     * <code>Room.OWNER_AFFILIATION</code>
	     * @param jids An array of JIDs to grant these permissions to
	     * @param callback The function to call once permission granting is complete
	     * @see #revoke
	     * @see #ban
	     */
	    public function grant(affiliation:String, jids:Array, callback:Function):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callbackScope = this;
	        iq.callbackName = "finish_admin";
	        iq.callback = callback;
	
	        for (var i:int=0; i < jids.length; i++) {
	            owner.addItem(affiliation, null, null, jids[i], null, null);
	        }
	
	        iq.addExtension(owner);
	        getConnection().send(iq);
	    }
	
	    /**
	     * Revokes all affiliations from the JIDs. This is the same as:
	     * <code>grant( Room.NO_AFFILIATION, jids )</code>
	     * 
	     * <p>If the process could not be completed, the room will dispatch the event
	     * <code>RoomEvent.ADMIN_ERROR</code>. Note: if the JID is banned from this room, 
	     * then this will also revoke the banned status.</p>
	     * 
	     * @param jids An array of JIDs to revoke affiliations from
	     * @param callback The function to call once revocation is complete
	     * @see #grant
	     * @see #ban
	     * @see #allow
	     */
	    public function revoke(jids:Array, callback:Function):void
	    {
	        grant(Room.NO_AFFILIATION, jids, callback);
	    }
	
	    /**
	     * Bans an array of JIDs from entering the room.  This is the same as:
	     * <code>Room.grant( OUTCAST_AFFILIATION, jid )</code>
	     *
	     * <p>If the process could not be completed, the room will dispatch the event
	     * <code>RoomEvent.ADMIN_ERROR</code>.</p>
	     * 
	     * @param jids An arry of JIDs to ban
	     * @param callback The function to call once banning is complete
	     * @see #grant
	     * @see #allow
	     */
	    public function ban(jids:Array, callback:Function):void
	    {
	        grant(Room.OUTCAST_AFFILIATION, jids, callback);
	    }
	
	    /**
	     * Allow a previously banned JIDs to enter this room.  This is the same as:
	     * Room.grant(NO_AFFILIATION, jid)
	     *
	     * <p>If the process could not be completed, the room will dispatch the event
	     * <code>RoomEvent.ADMIN_ERROR</code></p>
	     * 
	     * @param jids An array of JIDs to allow
	     * @param callback The function to call once allowing is complete
	     * @see #revoke
	     * @see #ban
	     */
	    public function allow( jids:Array, callback:Function ):void
	    {
	        grant(Room.NO_AFFILIATION, jids, callback);
	    }
	
	    /*
	     * The default handler for admin IQ messages
	     * Dispatches the adminError event if anything went wrong
	     */
	    private function finish_admin(iq:IQ):void
	    {
	        if (iq.type == IQ.ERROR_TYPE) {
	        	var e:RoomEvent = new RoomEvent(RoomEvent.ADMIN_ERROR);
	        	e.errorCondition = iq.errorCondition;
	        	e.errorMessage = iq.errorMessage;
	        	e.errorType = iq.errorType;
	        	e.errorCode = iq.errorCode;
	        	dispatchEvent(e);
	        }
	    }
	
	    /**
	     * Requests an affiliation list for a given affiliation with with room.
	     * This will either dispatch the event <code>RoomEvent.AFFILIATIONS</code> or 
	     * <code>RoomEvent.ADMIN_ERROR</code> depending on the result of the request.
	     *
	     * @param affiliation Use one of the following affiliations: <code>Room.NO_AFFILIATION</code>,
	     * <code>Room.OUTCAST_AFFILIATION</code>,
	     * <code>Room.MEMBER_AFFILIATION</code>,
	     * <code>Room.ADMIN_AFFILIATION</code>,
	     * <code>Room.OWNER_AFFILIATION</code>
	     * @see #revoke
	     * @see #grant
	     * @see #affiliations
	     */
	    public function requestAffiliations( affiliation:String ):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.GET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callbackScope = this;
	        iq.callbackName = "finish_requestAffiliates";
	
	        owner.addItem(affiliation);
	
	        iq.addExtension(owner);
	        getConnection().send(iq);
	    }
	
	    private function finish_requestAffiliates(iq:IQ):void
	    {
	        finish_admin(iq);
	        if (iq.type == IQ.RESULT_TYPE) {
	   
		            var owner:MUCOwnerExtension = iq.getAllExtensionsByNS(MUCOwnerExtension.NS)[0];
		            var items:Array = owner.getAllItems();
		            // trace("Affiliates: " + items);
		            var e:RoomEvent = new RoomEvent(RoomEvent.AFFILIATIONS);
		            e.data = items;
		            dispatchEvent(e);
	        	

	        }
	    }
	
		/**
		 * Destroys a reserved room.  If the room has been configured to be persistent,
	     * then it is optional that the server will permanently remove the room.
	     *
	     * @param reason A short description of why the room is being destroyed
	     * @param alternateJID A JID for current members to use as an alternate room to join 
	     * after the room has been destroyed. Like a postal forwarding address.
		 */
	    public function destroy( reason:String, alternateJID:String = null, callback:Function = null ):void
	    {
	        var iq:IQ = new IQ(getRoomJID(), IQ.SET_TYPE);
	        var owner:MUCOwnerExtension = new MUCOwnerExtension();
	
	        iq.callback = callback;
	        owner.destroy(reason, alternateJID);
	
	        iq.addExtension(owner);
	        myConnection.send(iq);
	    }
		
		private function updateRoomRoster( aPresence:Presence ):void
		{
			var userNickname:String = aPresence.from.split( "/" )[1];
			var userExts:Array = aPresence.getAllExtensionsByNS(MUCUserExtension.NS);
			var item:MUCItem = userExts[0].getAllItems()[0];
			var e:RoomEvent;
				
			if ( isThisUser( aPresence.from ) ) {
				myAffiliation = item.affiliation;
				myRole = item.role;
		
				if (!isActive() && aPresence.type != Presence.UNAVAILABLE_TYPE) {
					//trace("Room: becoming active: " + presence.getNode());
					active = true;
					e = new RoomEvent(RoomEvent.ROOM_JOIN);
					dispatchEvent(e);
				}
			}
		
			for(var i:int=0; i < length; i++) {
				//trace("Room: updateRoomRoster: checking: " + getItemAt(i).nickname);
		
				if( getItemAt( i ).nickname == userNickname ) {
		                
		    		// If the user left, remove the item
		        	if( aPresence.type == Presence.UNAVAILABLE_TYPE ) {
						//trace("Room: updateRoomRoster: leaving room: " + userNickname);
						
                        // Notify listeners that a user has left the room
		           		e = new RoomEvent(RoomEvent.USER_DEPARTURE);
		            	e.nickname = userNickname
		            	e.data = aPresence;
		            	dispatchEvent(e);
		            	removeItemAt (i);
		            }
		            else if (item != null) {
		            	var o:Object = getItemAt(i);
		            	o.affiliation = item.affiliation;
		            	o.role = item.role;
		            	o.show = aPresence.show != null ? aPresence.show : Presence.SHOW_NORMAL;
		            }
		            return;
		        }
		 	}
		        
		 	// Wasn't found, so add it
		 	if( aPresence.type != Presence.UNAVAILABLE_TYPE ) {
		 		addToRoomRoster( userNickname, 
		 		aPresence.show != null ? aPresence.show : Presence.SHOW_NORMAL, 
		 			item.affiliation, item.role, item.jid );
		
				e = new RoomEvent(RoomEvent.USER_JOIN);
				e.nickname = userNickname;
				e.data = aPresence;
				dispatchEvent(e);
			}	
		}
		
		private function addToRoomRoster( nickname:String, show:String, affiliation:String, role:String, jid:String ):void
		{
			addItem({nickname:nickname, show:show, affiliation:affiliation, role:role, jid:jid});
		}
		
		/**
		 * Determines if the <code>sender</code> parameter is the same
		 * as the room's JID.
		 *
		 * @param the room JID to test
		 * @return true if the passed JID matches the getRoomJID
		 */
		public function isThisRoom( sender:String ):Boolean
		{
			// Checks to see that sender is this room
			return sender.split( "/" )[0].toLowerCase() == getRoomJID().toLowerCase();
		}
	
		/**
		 * Determines if the <code>sender</code> param is the
		 * same as the user's JID.
		 *
		 * @param the room JID to test
		 * @return true if the passed JID matches the getUserJID()
		 */
		public function isThisUser( sender:String ):Boolean
		{
			// Case insensitive check that the sender is the same as the user
			return sender.toLowerCase() == getUserJID().toLowerCase();
		}
		
		/**
		 * The conference server to use for this room. Usually, this is a subdomain of 
		 * the primary XMPP server, like conference.myserver.com.
		 */
		public function get conferenceServer():String
		{
			return myJID.split("@")[1];
		}
		 
		/**
		 * @private
		 */
		public function set conferenceServer( aServer:String ):void
		{
			setRoomJID(roomName + "@" + aServer);
		}
		
		/**
		 * The room name that should be used when joining.
		 */
		public function get roomName():String
		{
			return myJID.split("@")[0];
		}
		
		/**
		 * @private
		 */
		public function set roomName( aName:String ):void
		{
			setRoomJID(aName + "@" + conferenceServer);
		}
		
		/**
		 * The nickname to use when joining.
		 */
		public function get nickname():String
		{
			return myNickname == null ? myConnection.username : myNickname;
		}
		
		/**
		 * @private
		 */
		public function set nickname( theNickname:String ):void
		{	
			if( isActive() ) {
				pendingNickname = theNickname;
				// var tempPresence:Presence = new Presence( getUserJID() );
				var tempPresence:Presence = new Presence( getUserJID() + "/" + pendingNickname );
				myConnection.send( tempPresence );
			}
			else {
				myNickname = theNickname;
			}
		}

		/**
		 * The password.
		 */
	    public function get password():String
	    {
	        return myPassword;
	    }
	
		/**
		 * @private
		 */
	    public function set password(aPassword:String):void
	    {
	        myPassword = aPassword;
	    } 
	
		/**
		 * The subject. (Read-only)
		 */
	    public function get subject():String
	    {
	        return mySubject;
	    }
	    
		/**
	     * @private
		 */ 
		override public function toString():String
	    {
	    	return '[object Room]';
	    }
	}
}