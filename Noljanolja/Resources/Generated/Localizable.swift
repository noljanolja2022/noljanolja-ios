// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add by contact
  internal static let addFriendAddByContact = L10n.tr("Localizable", "add_friend_add_by_contact", fallback: "Add by contact")
  /// Chat now
  internal static let addFriendChatNow = L10n.tr("Localizable", "add_friend_chat_now", fallback: "Chat now")
  /// Scan this QR code to add me
  internal static let addFriendScanQrToAdd = L10n.tr("Localizable", "add_friend_scan_qr_to_add", fallback: "Scan this QR code to add me")
  /// Search by phone number
  internal static let addFriendSearchByPhone = L10n.tr("Localizable", "add_friend_search_by_phone", fallback: "Search by phone number")
  /// Search QR code
  internal static let addFriendSearchByQr = L10n.tr("Localizable", "add_friend_search_by_qr", fallback: "Search QR code")
  /// Add Friends
  internal static let addFriendTitle = L10n.tr("Localizable", "add_friend_title", fallback: "Add Friends")
  /// %@ selected
  internal static func argsChatSelected(_ p1: Any) -> String {
    return L10n.tr("Localizable", "args_chat_selected", String(describing: p1), fallback: "%@ selected")
  }
  /// Do you want to Log out?
  internal static let askToLogout = L10n.tr("Localizable", "ask_to_logout", fallback: "Do you want to Log out?")
  /// Email verification
  internal static let authEmailVerification = L10n.tr("Localizable", "auth_email_verification", fallback: "Email verification")
  /// Identity verification complete!
  internal static let authEmailVerificationComplete = L10n.tr("Localizable", "auth_email_verification_complete", fallback: "Identity verification complete!")
  /// Find Email
  internal static let authFindEmail = L10n.tr("Localizable", "auth_find_email", fallback: "Find Email")
  /// Find password
  internal static let authFindPassword = L10n.tr("Localizable", "auth_find_password", fallback: "Find password")
  /// Find Password
  internal static let authForgotTitle = L10n.tr("Localizable", "auth_forgot_title", fallback: "Find Password")
  /// Identity verification complete!
  internal static let authIdentityComplete = L10n.tr("Localizable", "auth_identity_complete", fallback: "Identity verification complete!")
  /// Please log in with your temporary password
  /// and change your password.
  internal static let authLoginNewPassword = L10n.tr("Localizable", "auth_login_new_password", fallback: "Please log in with your temporary password\nand change your password.")
  /// Login with SNS
  internal static let authLoginWithSNS = L10n.tr("Localizable", "auth_login_with_SNS", fallback: "Login with SNS")
  /// You need to agree to the terms and conditions before signing up
  internal static let authNeedAgreementTerms = L10n.tr("Localizable", "auth_need_agreement_terms", fallback: "You need to agree to the terms and conditions before signing up")
  /// Resend temporary password
  internal static let authResendPassword = L10n.tr("Localizable", "auth_resend_password", fallback: "Resend temporary password")
  /// Temporary password to your email
  /// has been sent
  internal static let authResetEmailSended = L10n.tr("Localizable", "auth_reset_email_sended", fallback: "Temporary password to your email\nhas been sent")
  /// Step 1
  internal static let authSignupStep1 = L10n.tr("Localizable", "auth_signup_step1", fallback: "Step 1")
  /// Step 2
  internal static let authSignupStep2 = L10n.tr("Localizable", "auth_signup_step2", fallback: "Step 2")
  /// Step 3
  internal static let authSignupStep3 = L10n.tr("Localizable", "auth_signup_step3", fallback: "Step 3")
  /// Signup with email and password
  internal static let authSignupWithEmail = L10n.tr("Localizable", "auth_signup_with_email", fallback: "Signup with email and password")
  /// Verify email to finish
  internal static let authVerifyEmailFinish = L10n.tr("Localizable", "auth_verify_email_finish", fallback: "Verify email to finish")
  /// Welcome to NolgoBulja. Follow these steps to be our member.
  internal static let authWelcome = L10n.tr("Localizable", "auth_welcome", fallback: "Welcome to NolgoBulja. Follow these steps to be our member.")
  /// Change Password
  internal static let changePassword = L10n.tr("Localizable", "change_password", fallback: "Change Password")
  /// Album
  internal static let chatActionAlbum = L10n.tr("Localizable", "chat_action_album", fallback: "Album")
  /// Camera
  internal static let chatActionCamera = L10n.tr("Localizable", "chat_action_camera", fallback: "Camera")
  /// Contacts
  internal static let chatActionContacts = L10n.tr("Localizable", "chat_action_contacts", fallback: "Contacts")
  /// Copy
  internal static let chatActionCopy = L10n.tr("Localizable", "chat_action_copy", fallback: "Copy")
  /// Delete
  internal static let chatActionDelete = L10n.tr("Localizable", "chat_action_delete", fallback: "Delete")
  /// Events
  internal static let chatActionEvents = L10n.tr("Localizable", "chat_action_events", fallback: "Events")
  /// File
  internal static let chatActionFile = L10n.tr("Localizable", "chat_action_file", fallback: "File")
  /// Forward
  internal static let chatActionForward = L10n.tr("Localizable", "chat_action_forward", fallback: "Forward")
  /// Location
  internal static let chatActionLocation = L10n.tr("Localizable", "chat_action_location", fallback: "Location")
  /// Reply
  internal static let chatActionReply = L10n.tr("Localizable", "chat_action_reply", fallback: "Reply")
  /// Voice chat
  internal static let chatActionVoiceChat = L10n.tr("Localizable", "chat_action_voice_chat", fallback: "Voice chat")
  /// Wallet
  internal static let chatActionWallet = L10n.tr("Localizable", "chat_action_wallet", fallback: "Wallet")
  /// Record a video
  internal static let chatCameraRecordVideo = L10n.tr("Localizable", "chat_camera_record_video", fallback: "Record a video")
  /// Take a photo
  internal static let chatCameraTakePhoto = L10n.tr("Localizable", "chat_camera_take_photo", fallback: "Take a photo")
  /// This message will be deleted on your chat screen
  internal static let chatConfirmDeleteMessage = L10n.tr("Localizable", "chat_confirm_delete_message", fallback: "This message will be deleted on your chat screen")
  /// You want to delete this message
  internal static let chatConfirmDeleteMessageTitle = L10n.tr("Localizable", "chat_confirm_delete_message_title", fallback: "You want to delete this message")
  /// Forward Message
  internal static let chatForwardMessage = L10n.tr("Localizable", "chat_forward_message", fallback: "Forward Message")
  /// Aa
  internal static let chatInputHint = L10n.tr("Localizable", "chat_input_hint", fallback: "Aa")
  /// %@ has invited %@
  internal static func chatMessageEventJoined(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "chat_message_event_joined", String(describing: p1), String(describing: p2), fallback: "%@ has invited %@")
  }
  /// %@ has left the conversation
  internal static func chatMessageEventLeft(_ p1: Any) -> String {
    return L10n.tr("Localizable", "chat_message_event_left", String(describing: p1), fallback: "%@ has left the conversation")
  }
  /// %@ has updated conversation %@
  internal static func chatMessageEventUpdated(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "chat_message_event_updated", String(describing: p1), String(describing: p2), fallback: "%@ has updated conversation %@")
  }
  /// Please tap this button to start a new chat
  internal static let chatNewChatTooltip = L10n.tr("Localizable", "chat_new_chat_tooltip", fallback: "Please tap this button to start a new chat")
  /// You were removed from conversation  by %@
  internal static func chatRemovedConversation(_ p1: Any) -> String {
    return L10n.tr("Localizable", "chat_removed_conversation", String(describing: p1), fallback: "You were removed from conversation  by %@")
  }
  /// All friends
  internal static let chatSettingAllFriends = L10n.tr("Localizable", "chat_setting_all_friends", fallback: "All friends")
  /// Users who use NolgoBulja app in your Directory will be synchronized automatically with friendlist in NolgoBulja.
  internal static let chatSettingAutoAddDescription = L10n.tr("Localizable", "chat_setting_auto_add_description", fallback: "Users who use NolgoBulja app in your Directory will be synchronized automatically with friendlist in NolgoBulja.")
  /// Automatically add friends
  internal static let chatSettingAutoAddFriend = L10n.tr("Localizable", "chat_setting_auto_add_friend", fallback: "Automatically add friends")
  /// Blocked friends
  internal static let chatSettingBlockedFriends = L10n.tr("Localizable", "chat_setting_blocked_friends", fallback: "Blocked friends")
  /// Friends management
  internal static let chatSettingFriendManagement = L10n.tr("Localizable", "chat_setting_friend_management", fallback: "Friends management")
  /// Hiden friends
  internal static let chatSettingHideFriends = L10n.tr("Localizable", "chat_setting_hide_friends", fallback: "Hiden friends")
  /// Change avatar
  internal static let chatSettingsChangeAvatar = L10n.tr("Localizable", "chat_settings_change_avatar", fallback: "Change avatar")
  /// Chat Settings
  internal static let chatSettingsTitle = L10n.tr("Localizable", "chat_settings_title", fallback: "Chat Settings")
  /// You received a file
  internal static let chatsMessageFile = L10n.tr("Localizable", "chats_message_file", fallback: "You received a file")
  /// You sent a file
  internal static let chatsMessageMyFile = L10n.tr("Localizable", "chats_message_my_file", fallback: "You sent a file")
  /// You sent a photo
  internal static let chatsMessageMyPhoto = L10n.tr("Localizable", "chats_message_my_photo", fallback: "You sent a photo")
  /// You sent a sticker
  internal static let chatsMessageMySticker = L10n.tr("Localizable", "chats_message_my_sticker", fallback: "You sent a sticker")
  /// You sent a message
  internal static let chatsMessageMyUnknown = L10n.tr("Localizable", "chats_message_my_unknown", fallback: "You sent a message")
  /// You sent a video
  internal static let chatsMessageMyVideo = L10n.tr("Localizable", "chats_message_my_video", fallback: "You sent a video")
  /// You received a photo
  internal static let chatsMessagePhoto = L10n.tr("Localizable", "chats_message_photo", fallback: "You received a photo")
  /// You received a sticker
  internal static let chatsMessageSticker = L10n.tr("Localizable", "chats_message_sticker", fallback: "You received a sticker")
  /// You received a message
  internal static let chatsMessageUnknown = L10n.tr("Localizable", "chats_message_unknown", fallback: "You received a message")
  /// You received a video
  internal static let chatsMessageVideo = L10n.tr("Localizable", "chats_message_video", fallback: "You received a video")
  /// New Chat
  internal static let chatsNewChat = L10n.tr("Localizable", "chats_new_chat", fallback: "New Chat")
  /// Chats
  internal static let chatsTitle = L10n.tr("Localizable", "chats_title", fallback: "Chats")
  /// Checkout and play
  internal static let checkoutAndPlay = L10n.tr("Localizable", "checkout_and_play", fallback: "Checkout and play")
  /// Welcome to NolgoBulja. We will be coming soon. Thank you.
  internal static let comingSoonDescription = L10n.tr("Localizable", "coming_soon_description", fallback: "Welcome to NolgoBulja. We will be coming soon. Thank you.")
  /// Admin
  internal static let commonAdmin = L10n.tr("Localizable", "common_admin", fallback: "Admin")
  /// Agree
  internal static let commonAgree = L10n.tr("Localizable", "common_agree", fallback: "Agree")
  /// All
  internal static let commonAll = L10n.tr("Localizable", "common_all", fallback: "All")
  /// Cancel
  internal static let commonCancel = L10n.tr("Localizable", "common_cancel", fallback: "Cancel")
  /// Chat
  internal static let commonChat = L10n.tr("Localizable", "common_chat", fallback: "Chat")
  /// Complete
  internal static let commonComplete = L10n.tr("Localizable", "common_complete", fallback: "Complete")
  /// Confirm
  internal static let commonConfirm = L10n.tr("Localizable", "common_confirm", fallback: "Confirm")
  /// Continue
  internal static let commonContinue = L10n.tr("Localizable", "common_continue", fallback: "Continue")
  /// Copy
  internal static let commonCopy = L10n.tr("Localizable", "common_copy", fallback: "Copy")
  /// Copied in clipboard
  internal static let commonCopySuccess = L10n.tr("Localizable", "common_copy_success", fallback: "Copied in clipboard")
  /// Disagree
  internal static let commonDisagree = L10n.tr("Localizable", "common_disagree", fallback: "Disagree")
  /// Download
  internal static let commonDownload = L10n.tr("Localizable", "common_download", fallback: "Download")
  /// Edit
  internal static let commonEdit = L10n.tr("Localizable", "common_edit", fallback: "Edit")
  /// An unexpected error has occurred. Please try again.
  internal static let commonErrorDescription = L10n.tr("Localizable", "common_error_description", fallback: "An unexpected error has occurred. Please try again.")
  /// Error
  internal static let commonErrorTitle = L10n.tr("Localizable", "common_error_title", fallback: "Error")
  /// Exit
  internal static let commonExit = L10n.tr("Localizable", "common_exit", fallback: "Exit")
  /// Forwarded
  internal static let commonForwarded = L10n.tr("Localizable", "common_forwarded", fallback: "Forwarded")
  /// Friends
  internal static let commonFriends = L10n.tr("Localizable", "common_friends", fallback: "Friends")
  /// Id
  internal static let commonId = L10n.tr("Localizable", "common_id", fallback: "Id")
  /// [Image]
  internal static let commonImage = L10n.tr("Localizable", "common_image", fallback: "[Image]")
  /// Loading...
  internal static let commonLoading = L10n.tr("Localizable", "common_loading", fallback: "Loading...")
  /// Log out
  internal static let commonLogOut = L10n.tr("Localizable", "common_log_out", fallback: "Log out")
  /// Log in
  internal static let commonLogin = L10n.tr("Localizable", "common_login", fallback: "Log in")
  /// Members
  internal static let commonMembers = L10n.tr("Localizable", "common_members", fallback: "Members")
  /// More
  internal static let commonMore = L10n.tr("Localizable", "common_more", fallback: "More")
  /// Next
  internal static let commonNext = L10n.tr("Localizable", "common_next", fallback: "Next")
  /// No
  internal static let commonNo = L10n.tr("Localizable", "common_no", fallback: "No")
  /// OK
  internal static let commonOk = L10n.tr("Localizable", "common_ok", fallback: "OK")
  /// Points
  internal static let commonPoints = L10n.tr("Localizable", "common_points", fallback: "Points")
  /// Previous
  internal static let commonPrevious = L10n.tr("Localizable", "common_previous", fallback: "Previous")
  /// Reload
  internal static let commonReload = L10n.tr("Localizable", "common_reload", fallback: "Reload")
  /// Save
  internal static let commonSave = L10n.tr("Localizable", "common_save", fallback: "Save")
  /// Saved
  internal static let commonSaved = L10n.tr("Localizable", "common_saved", fallback: "Saved")
  /// Search
  internal static let commonSearch = L10n.tr("Localizable", "common_search", fallback: "Search")
  /// Send
  internal static let commonSend = L10n.tr("Localizable", "common_send", fallback: "Send")
  /// Send to
  internal static let commonSendTo = L10n.tr("Localizable", "common_send_to", fallback: "Send to")
  /// Setting
  internal static let commonSetting = L10n.tr("Localizable", "common_setting", fallback: "Setting")
  /// Share
  internal static let commonShare = L10n.tr("Localizable", "common_share", fallback: "Share")
  /// Share success
  internal static let commonShareSuccess = L10n.tr("Localizable", "common_share_success", fallback: "Share success")
  /// Shop
  internal static let commonShop = L10n.tr("Localizable", "common_shop", fallback: "Shop")
  /// Size %@
  internal static func commonSize(_ p1: Any) -> String {
    return L10n.tr("Localizable", "common_size", String(describing: p1), fallback: "Size %@")
  }
  /// Skip
  internal static let commonSkip = L10n.tr("Localizable", "common_skip", fallback: "Skip")
  /// Sorry!
  internal static let commonSorry = L10n.tr("Localizable", "common_sorry", fallback: "Sorry!")
  /// [Sticker]
  internal static let commonSticker = L10n.tr("Localizable", "common_sticker", fallback: "[Sticker]")
  /// Success
  internal static let commonSuccess = L10n.tr("Localizable", "common_success", fallback: "Success")
  /// Today
  internal static let commonToday = L10n.tr("Localizable", "common_today", fallback: "Today")
  /// Try again
  internal static let commonTryAgain = L10n.tr("Localizable", "common_try_again", fallback: "Try again")
  /// [Undefined]
  internal static let commonUndefined = L10n.tr("Localizable", "common_undefined", fallback: "[Undefined]")
  /// Unexpected Error
  internal static let commonUnexpectedError = L10n.tr("Localizable", "common_unexpected_error", fallback: "Unexpected Error")
  /// Use
  internal static let commonUse = L10n.tr("Localizable", "common_use", fallback: "Use")
  /// Use now
  internal static let commonUseNow = L10n.tr("Localizable", "common_use_now", fallback: "Use now")
  /// Verification
  internal static let commonVerification = L10n.tr("Localizable", "common_verification", fallback: "Verification")
  /// Warning
  internal static let commonWarning = L10n.tr("Localizable", "common_warning", fallback: "Warning")
  /// Withdrawal
  internal static let commonWithdrwal = L10n.tr("Localizable", "common_withdrwal", fallback: "Withdrawal")
  /// Yes
  internal static let commonYes = L10n.tr("Localizable", "common_yes", fallback: "Yes")
  /// Yesterday
  internal static let commonYesterday = L10n.tr("Localizable", "common_yesterday", fallback: "Yesterday")
  /// You
  internal static let commonYou = L10n.tr("Localizable", "common_you", fallback: "You")
  /// Please enter your confirm password
  internal static let confirmPasswordHintText = L10n.tr("Localizable", "confirm_password_hint_text", fallback: "Please enter your confirm password")
  /// Search by name/Phone number
  internal static let contactSearchHint = L10n.tr("Localizable", "contact_search_hint", fallback: "Search by name/Phone number")
  /// Sorry, this user is not in your contacts
  internal static let contactsNotFound = L10n.tr("Localizable", "contacts_not_found", fallback: "Sorry, this user is not in your contacts")
  /// Start Chatting
  internal static let contactsStartChat = L10n.tr("Localizable", "contacts_start_chat", fallback: "Start Chatting")
  /// Add members
  internal static let contactsTitleAddMemmber = L10n.tr("Localizable", "contacts_title_add_memmber", fallback: "Add members")
  /// Group chat
  internal static let contactsTitleGroup = L10n.tr("Localizable", "contacts_title_group", fallback: "Group chat")
  /// Normal chat
  internal static let contactsTitleNormal = L10n.tr("Localizable", "contacts_title_normal", fallback: "Normal chat")
  /// Secret chat
  internal static let contactsTitleSecret = L10n.tr("Localizable", "contacts_title_secret", fallback: "Secret chat")
  /// %@ created conversation
  internal static func conversationCreate(_ p1: Any) -> String {
    return L10n.tr("Localizable", "conversation_create", String(describing: p1), fallback: "%@ created conversation")
  }
  /// Add friends to chat now.
  internal static let conversationEmpty = L10n.tr("Localizable", "conversation_empty", fallback: "Add friends to chat now.")
  /// Conversation has changed
  internal static let conversationHasChanged = L10n.tr("Localizable", "conversation_has_changed", fallback: "Conversation has changed")
  /// Search
  internal static let countriesSearch = L10n.tr("Localizable", "countries_search", fallback: "Search")
  /// Select countries/regions
  internal static let countriesTitle = L10n.tr("Localizable", "countries_title", fallback: "Select countries/regions")
  /// Custom service center
  internal static let customServiceCenter = L10n.tr("Localizable", "custom_service_center", fallback: "Custom service center")
  /// Download failure
  internal static let downloadFailure = L10n.tr("Localizable", "download_failure", fallback: "Download failure")
  /// Download success
  internal static let downloadSuccess = L10n.tr("Localizable", "download_success", fallback: "Download success")
  /// Add members
  internal static let editChatAddMembers = L10n.tr("Localizable", "edit_chat_add_members", fallback: "Add members")
  /// Block user
  internal static let editChatBlockUser = L10n.tr("Localizable", "edit_chat_block_user", fallback: "Block user")
  /// Change nickname
  internal static let editChatChangeNickname = L10n.tr("Localizable", "edit_chat_change_nickname", fallback: "Change nickname")
  /// Chat room adjustment
  internal static let editChatChangeRoomAdjustment = L10n.tr("Localizable", "edit_chat_change_room_adjustment", fallback: "Chat room adjustment")
  /// Name of group chat
  internal static let editChatChangeRoomAdjustmentDescription = L10n.tr("Localizable", "edit_chat_change_room_adjustment_description", fallback: "Name of group chat")
  /// Change Chat room‘s name
  internal static let editChatChangeRoomName = L10n.tr("Localizable", "edit_chat_change_room_name", fallback: "Change Chat room‘s name")
  /// Delete chat history
  internal static let editChatDeleteChatHistory = L10n.tr("Localizable", "edit_chat_delete_chat_history", fallback: "Delete chat history")
  /// Find message
  internal static let editChatFindMessage = L10n.tr("Localizable", "edit_chat_find_message", fallback: "Find message")
  /// Leave chat room
  internal static let editChatLeaveChat = L10n.tr("Localizable", "edit_chat_leave_chat", fallback: "Leave chat room")
  /// Make admin
  internal static let editChatMakeAdmin = L10n.tr("Localizable", "edit_chat_make_admin", fallback: "Make admin")
  /// Media, files, links
  internal static let editChatMediaFilesLinks = L10n.tr("Localizable", "edit_chat_media_files_links", fallback: "Media, files, links")
  /// Remove user
  internal static let editChatRemoveUser = L10n.tr("Localizable", "edit_chat_remove_user", fallback: "Remove user")
  /// Secret Chat
  internal static let editChatSecretChat = L10n.tr("Localizable", "edit_chat_secret_chat", fallback: "Secret Chat")
  /// Theme Chat
  internal static let editChatThemeChat = L10n.tr("Localizable", "edit_chat_theme_chat", fallback: "Theme Chat")
  /// Turn off notification
  internal static let editChatTurnOffNotification = L10n.tr("Localizable", "edit_chat_turn_off_notification", fallback: "Turn off notification")
  /// This user will be assigned to admin for this chat.
  internal static let editChatWarningAdminDescription = L10n.tr("Localizable", "edit_chat_warning_admin_description", fallback: "This user will be assigned to admin for this chat.")
  /// Are you sure to assign admin this user?
  internal static let editChatWarningAdminTitle = L10n.tr("Localizable", "edit_chat_warning_admin_title", fallback: "Are you sure to assign admin this user?")
  /// This user will be blocked to send or receive message with you.
  internal static let editChatWarningBlockDescription = L10n.tr("Localizable", "edit_chat_warning_block_description", fallback: "This user will be blocked to send or receive message with you.")
  /// Are you sure to block this user?
  internal static let editChatWarningBlockTitle = L10n.tr("Localizable", "edit_chat_warning_block_title", fallback: "Are you sure to block this user?")
  /// If you leave, all the chat and chat history will be deleted.
  internal static let editChatWarningLeaveDescription = L10n.tr("Localizable", "edit_chat_warning_leave_description", fallback: "If you leave, all the chat and chat history will be deleted.")
  /// Are you sure to leave this chat?
  internal static let editChatWarningLeaveTitle = L10n.tr("Localizable", "edit_chat_warning_leave_title", fallback: "Are you sure to leave this chat?")
  /// This user will be removed from this chat.
  internal static let editChatWarningRemoveDescription = L10n.tr("Localizable", "edit_chat_warning_remove_description", fallback: "This user will be removed from this chat.")
  /// Are you sure to remove this user?
  internal static let editChatWarningRemoveTitle = L10n.tr("Localizable", "edit_chat_warning_remove_title", fallback: "Are you sure to remove this user?")
  /// Edit member infomation
  internal static let editMemberInfomation = L10n.tr("Localizable", "edit_member_infomation", fallback: "Edit member infomation")
  /// Please enter your email
  internal static let emailHintText = L10n.tr("Localizable", "email_hint_text", fallback: "Please enter your email")
  /// Enter phone number
  internal static let enterPhoneNumber = L10n.tr("Localizable", "enter_phone_number", fallback: "Enter phone number")
  /// Phone is not valid
  internal static let errorPhoneInvalid = L10n.tr("Localizable", "error_phone_invalid", fallback: "Phone is not valid")
  /// This phone number is not available
  internal static let errorPhoneIsNotAvailable = L10n.tr("Localizable", "error_phone_is_not_available", fallback: "This phone number is not available")
  /// Sorry! This QR code is invalid
  internal static let errorQrNotValid = L10n.tr("Localizable", "error_qr_not_valid", fallback: "Sorry! This QR code is invalid")
  /// Unexpected Error
  internal static let errorUnexpected = L10n.tr("Localizable", "error_unexpected", fallback: "Unexpected Error")
  /// Exchange Account Management
  internal static let exchangeAccountManagement = L10n.tr("Localizable", "exchange_account_management", fallback: "Exchange Account Management")
  /// Exchange Cash
  internal static let exchangeCashTitle = L10n.tr("Localizable", "exchange_cash_title", fallback: "Exchange Cash")
  /// Exchange Point to Cash
  internal static let exchangeDesciption = L10n.tr("Localizable", "exchange_desciption", fallback: "Exchange Point to Cash")
  /// Exchange
  internal static let exchangeTitle = L10n.tr("Localizable", "exchange_title", fallback: "Exchange")
  /// Forgot your password?
  internal static let forgotPassword = L10n.tr("Localizable", "forgot_password", fallback: "Forgot your password?")
  /// Friendlist
  internal static let friendList = L10n.tr("Localizable", "friend_list", fallback: "Friendlist")
  /// Full agreement
  internal static let fullAgreement = L10n.tr("Localizable", "full_agreement", fallback: "Full agreement")
  /// + %@ Points after watching
  internal static func getPointAfterWatching(_ p1: Any) -> String {
    return L10n.tr("Localizable", "get_point_after_watching", String(describing: p1), fallback: "+ %@ Points after watching")
  }
  /// Deduction Cash
  internal static let giftDeductionCash = L10n.tr("Localizable", "gift_deduction_cash", fallback: "Deduction Cash")
  /// Deduction point
  internal static let giftDeductionPoint = L10n.tr("Localizable", "gift_deduction_point", fallback: "Deduction point")
  /// Give this Code to the cashier to get pradoducts
  internal static let giftGiveCodeToCashier = L10n.tr("Localizable", "gift_give_code_to_cashier", fallback: "Give this Code to the cashier to get pradoducts")
  /// Holding Cash
  internal static let giftHoldingCash = L10n.tr("Localizable", "gift_holding_cash", fallback: "Holding Cash")
  /// Holding points
  internal static let giftHoldingPoint = L10n.tr("Localizable", "gift_holding_point", fallback: "Holding points")
  /// Purchase
  internal static let giftPurchase = L10n.tr("Localizable", "gift_purchase", fallback: "Purchase")
  /// Remaining Cash
  internal static let giftRemainingCash = L10n.tr("Localizable", "gift_remaining_cash", fallback: "Remaining Cash")
  /// Remaining points
  internal static let giftRemainingPoint = L10n.tr("Localizable", "gift_remaining_point", fallback: "Remaining points")
  /// %@ P
  internal static func giftValuePoint(_ p1: Any) -> String {
    return L10n.tr("Localizable", "gift_value_point", String(describing: p1), fallback: "%@ P")
  }
  /// Hello %@
  internal static func helloUser(_ p1: Any) -> String {
    return L10n.tr("Localizable", "hello_user", String(describing: p1), fallback: "Hello %@")
  }
  /// Chats
  internal static let homeChats = L10n.tr("Localizable", "home_chats", fallback: "Chats")
  /// News
  internal static let homeNews = L10n.tr("Localizable", "home_news", fallback: "News")
  /// Shop
  internal static let homeShop = L10n.tr("Localizable", "home_shop", fallback: "Shop")
  /// Wallet
  internal static let homeWallet = L10n.tr("Localizable", "home_wallet", fallback: "Wallet")
  /// Watch
  internal static let homeWatch = L10n.tr("Localizable", "home_watch", fallback: "Watch")
  /// How to refer a friend
  internal static let howToRefer = L10n.tr("Localizable", "how_to_refer", fallback: "How to refer a friend")
  /// Email is not valid
  internal static let invalidEmailFormat = L10n.tr("Localizable", "invalid_email_format", fallback: "Email is not valid")
  /// Invalid referral code
  internal static let invalidReferral = L10n.tr("Localizable", "invalid_referral", fallback: "Invalid referral code")
  /// Sorry, Please check your code again or skip this step
  internal static let invalidReferralMessage = L10n.tr("Localizable", "invalid_referral_message", fallback: "Sorry, Please check your code again or skip this step")
  /// Invite Friends to get benefits
  internal static let inviteToGetBenefits = L10n.tr("Localizable", "invite_to_get_benefits", fallback: "Invite Friends to get benefits")
  /// Let’s join and Play
  internal static let joinPlay = L10n.tr("Localizable", "join_play", fallback: "Let’s join and Play")
  /// Sign in with Apple
  internal static let loginAppleButton = L10n.tr("Localizable", "login_apple_button", fallback: "Sign in with Apple")
  /// You will receive a code to verify to this phone number via text message.
  internal static let loginConfirmPhoneDescription = L10n.tr("Localizable", "login_confirm_phone_description", fallback: "You will receive a code to verify to this phone number via text message.")
  /// Country
  internal static let loginCountryInputLabel = L10n.tr("Localizable", "login_country_input_label", fallback: "Country")
  /// Connect with Google
  internal static let loginGoogleButton = L10n.tr("Localizable", "login_google_button", fallback: "Connect with Google")
  /// Welcome to NolgoBulja. Please connect your Google account to continue.
  internal static let loginGoogleDescription = L10n.tr("Localizable", "login_google_description", fallback: "Welcome to NolgoBulja. Please connect your Google account to continue.")
  /// Please input the correct phone number since this number will be used to verify your account.
  internal static let loginInvalidPhoneDescription = L10n.tr("Localizable", "login_invalid_phone_description", fallback: "Please input the correct phone number since this number will be used to verify your account.")
  /// Incorrect Number
  internal static let loginInvalidPhoneTitle = L10n.tr("Localizable", "login_invalid_phone_title", fallback: "Incorrect Number")
  /// Welcome to NolgoBulja. Please enter your Phone number to join continue.
  internal static let loginPhoneDescription = L10n.tr("Localizable", "login_phone_description", fallback: "Welcome to NolgoBulja. Please enter your Phone number to join continue.")
  /// Phone Number
  internal static let loginPhoneInputLabel = L10n.tr("Localizable", "login_phone_input_label", fallback: "Phone Number")
  /// Maybe you like
  internal static let maybeYouLike = L10n.tr("Localizable", "maybe_you_like", fallback: "Maybe you like")
  /// Announcement
  internal static let menuAnnouncement = L10n.tr("Localizable", "menu_announcement", fallback: "Announcement")
  /// Check out and play
  internal static let menuCheckoutAndPlay = L10n.tr("Localizable", "menu_checkout_and_play", fallback: "Check out and play")
  /// Exchanging money
  internal static let menuExchangeMoney = L10n.tr("Localizable", "menu_exchange_money", fallback: "Exchanging money")
  /// Let's join and play
  internal static let menuJoinAndPlay = L10n.tr("Localizable", "menu_join_and_play", fallback: "Let's join and play")
  /// Let's play while watching the video
  internal static let menuPlayVideo = L10n.tr("Localizable", "menu_play_video", fallback: "Let's play while watching the video")
  /// Point details
  internal static let menuPointDetails = L10n.tr("Localizable", "menu_point_details", fallback: "Point details")
  /// Menu
  internal static let menuTitle = L10n.tr("Localizable", "menu_title", fallback: "Menu")
  /// %@ min
  internal static func minutes(_ p1: Any) -> String {
    return L10n.tr("Localizable", "minutes", String(describing: p1), fallback: "%@ min")
  }
  /// My Info
  internal static let myInfo = L10n.tr("Localizable", "my_info", fallback: "My Info")
  /// My Page
  internal static let myPage = L10n.tr("Localizable", "my_page", fallback: "My Page")
  /// My ranking
  internal static let myRankingTitle = L10n.tr("Localizable", "my_ranking_title", fallback: "My ranking")
  /// Open link
  internal static let openLink = L10n.tr("Localizable", "open_link", fallback: "Open link")
  /// We've sent a text message with your verification code to
  internal static let otpDescription = L10n.tr("Localizable", "otp_description", fallback: "We've sent a text message with your verification code to")
  /// Please make sure you input the correct code received via messages.
  internal static let otpInvalidOtpDescription = L10n.tr("Localizable", "otp_invalid_otp_description", fallback: "Please make sure you input the correct code received via messages.")
  /// Incorrect Code
  internal static let otpInvalidOtpTitle = L10n.tr("Localizable", "otp_invalid_otp_title", fallback: "Incorrect Code")
  /// Resend Code
  internal static let otpResendCode = L10n.tr("Localizable", "otp_resend_code", fallback: "Resend Code")
  /// Resend code in %@ seconds
  internal static func otpResendCodeWaiting(_ p1: Any) -> String {
    return L10n.tr("Localizable", "otp_resend_code_waiting", String(describing: p1), fallback: "Resend code in %@ seconds")
  }
  /// Enter verification code
  internal static let otpTitle = L10n.tr("Localizable", "otp_title", fallback: "Enter verification code")
  /// Verifying...
  internal static let otpVerifying = L10n.tr("Localizable", "otp_verifying", fallback: "Verifying...")
  /// Please enter your password
  internal static let passwordHintText = L10n.tr("Localizable", "password_hint_text", fallback: "Please enter your password")
  /// Permission
  internal static let permission = L10n.tr("Localizable", "permission", fallback: "Permission")
  /// Accept
  internal static let permissionAccept = L10n.tr("Localizable", "permission_accept", fallback: "Accept")
  /// To help you access gallery on Nolgobulja, allow Nolgobulja access to your media files.
  internal static let permissionAccessStorageDescription = L10n.tr("Localizable", "permission_access_storage_description", fallback: "To help you access gallery on Nolgobulja, allow Nolgobulja access to your media files.")
  /// To help you send image or video, allow Nolgobulja access to your camera.
  internal static let permissionCamera = L10n.tr("Localizable", "permission_camera", fallback: "To help you send image or video, allow Nolgobulja access to your camera.")
  /// To help you message friends and family on Nolgobulja, allow Nolgobulja access to your contacts.
  internal static let permissionContactsDescription = L10n.tr("Localizable", "permission_contacts_description", fallback: "To help you message friends and family on Nolgobulja, allow Nolgobulja access to your contacts.")
  /// Settings
  internal static let permissionGoToSettings = L10n.tr("Localizable", "permission_go_to_settings", fallback: "Settings")
  /// Permit NolgoBulja to send you notification in order to
  /// conect with your friends.
  internal static let permissionNotificationDescription = L10n.tr("Localizable", "permission_notification_description", fallback: "Permit NolgoBulja to send you notification in order to\nconect with your friends.")
  /// Turn on notification
  /// for NolgoBulja
  internal static let permissionNotificationTitle = L10n.tr("Localizable", "permission_notification_title", fallback: "Turn on notification\nfor NolgoBulja")
  /// You're unable to use this feature without the required permissions. 
  /// Tap the Settings button to allow Nolgobulja to access the required permission.
  internal static let permissionRequiredDescription = L10n.tr("Localizable", "permission_required_description", fallback: "You're unable to use this feature without the required permissions. \nTap the Settings button to allow Nolgobulja to access the required permission.")
  /// Please enter referral code to get bonus gifts.
  internal static let pleaseEnterReferralCode = L10n.tr("Localizable", "please_enter_referral_code", fallback: "Please enter referral code to get bonus gifts.")
  /// Go to Check Out Benefits
  internal static let referalGoToDetail = L10n.tr("Localizable", "referal_go_to_detail", fallback: "Go to Check Out Benefits")
  /// Referral code
  internal static let referralCode = L10n.tr("Localizable", "referral_code", fallback: "Referral code")
  /// * Even if a friend manually enters the referral code after copying and sending it. You can participate in the friend referral event.
  internal static let referralDescription = L10n.tr("Localizable", "referral_description", fallback: "* Even if a friend manually enters the referral code after copying and sending it. You can participate in the friend referral event.")
  /// Congratulation! You and your friend have just  got %@ Points from referal code.
  internal static func referralReceivePoint(_ p1: Any) -> String {
    return L10n.tr("Localizable", "referral_receive_point", String(describing: p1), fallback: "Congratulation! You and your friend have just  got %@ Points from referal code.")
  }
  /// Send invitation link. Just tap the button!
  internal static let referralStep1 = L10n.tr("Localizable", "referral_step_1", fallback: "Send invitation link. Just tap the button!")
  /// Invite link to friend will be sent
  internal static let referralStep2 = L10n.tr("Localizable", "referral_step_2", fallback: "Invite link to friend will be sent")
  /// Via the link sent to you. Proceed to membership registration
  internal static let referralStep3 = L10n.tr("Localizable", "referral_step_3", fallback: "Via the link sent to you. Proceed to membership registration")
  /// When all courses are completed. Friends and I also earn 1,000P!
  internal static let referralStep4 = L10n.tr("Localizable", "referral_step_4", fallback: "When all courses are completed. Friends and I also earn 1,000P!")
  /// REQUEST POINT
  internal static let requestPoint = L10n.tr("Localizable", "request_point", fallback: "REQUEST POINT")
  /// Let's Play Log in
  internal static let requireLoginButton = L10n.tr("Localizable", "require_login_button", fallback: "Let's Play Log in")
  /// Log in to play
  /// Use a variety of services!
  internal static let requireLoginDescription = L10n.tr("Localizable", "require_login_description", fallback: "Log in to play\nUse a variety of services!")
  /// Let's Play Start the service
  internal static let requireLoginTitle = L10n.tr("Localizable", "require_login_title", fallback: "Let's Play Start the service")
  /// Verify Email
  internal static let requireVerifyButton = L10n.tr("Localizable", "require_verify_button", fallback: "Verify Email")
  /// Verify email to play
  /// Use a variety of services
  internal static let requireVerifyDescription = L10n.tr("Localizable", "require_verify_description", fallback: "Verify email to play\nUse a variety of services")
  /// Scan QR code
  internal static let scanQrCodeTitle = L10n.tr("Localizable", "scan_qr_code_title", fallback: "Scan QR code")
  /// %@ sec
  internal static func seconds(_ p1: Any) -> String {
    return L10n.tr("Localizable", "seconds", String(describing: p1), fallback: "%@ sec")
  }
  /// Send invitation link
  internal static let sendInviteLink = L10n.tr("Localizable", "send_invite_link", fallback: "Send invitation link")
  /// SEND POINT
  internal static let sendPoint = L10n.tr("Localizable", "send_point", fallback: "SEND POINT")
  /// Service Guide
  internal static let serviceGuide = L10n.tr("Localizable", "service_guide", fallback: "Service Guide")
  /// About us
  internal static let settingAboutUsTitle = L10n.tr("Localizable", "setting_about_us_title", fallback: "About us")
  /// Address
  internal static let settingAddressTitle = L10n.tr("Localizable", "setting_address_title", fallback: "Address")
  /// Clear cache data
  internal static let settingClearCacheData = L10n.tr("Localizable", "setting_clear_cache_data", fallback: "Clear cache data")
  /// Clear cache data completed.
  internal static let settingClearCacheSuccessDescription = L10n.tr("Localizable", "setting_clear_cache_success_description", fallback: "Clear cache data completed.")
  /// Company Name
  internal static let settingCompanyNameTitle = L10n.tr("Localizable", "setting_company_name_title", fallback: "Company Name")
  /// Company Registration Number
  internal static let settingCompanyRegistrationNumberTitle = L10n.tr("Localizable", "setting_company_registration_number_title", fallback: "Company Registration Number")
  /// Current version %@
  internal static func settingCurrentVersion(_ p1: Any) -> String {
    return L10n.tr("Localizable", "setting_current_version", String(describing: p1), fallback: "Current version %@")
  }
  /// Exchange account management
  internal static let settingExchangeAccountManagement = L10n.tr("Localizable", "setting_exchange_account_management", fallback: "Exchange account management")
  /// FAQ
  internal static let settingFaq = L10n.tr("Localizable", "setting_faq", fallback: "FAQ")
  /// FAQ
  internal static let settingFaqTitle = L10n.tr("Localizable", "setting_faq_title", fallback: "FAQ")
  /// Open source license
  internal static let settingLicenseTitle = L10n.tr("Localizable", "setting_license_title", fallback: "Open source license")
  /// Name
  internal static let settingName = L10n.tr("Localizable", "setting_name", fallback: "Name")
  /// Open source license
  internal static let settingOpenSourceLicence = L10n.tr("Localizable", "setting_open_source_licence", fallback: "Open source license")
  /// Open source license
  internal static let settingOpenSourceLicense = L10n.tr("Localizable", "setting_open_source_license", fallback: "Open source license")
  /// Phone call
  internal static let settingPhoneCallTitle = L10n.tr("Localizable", "setting_phone_call_title", fallback: "Phone call")
  /// Phone number
  internal static let settingPhoneNumber = L10n.tr("Localizable", "setting_phone_number", fallback: "Phone number")
  /// App push notification
  internal static let settingPushNotification = L10n.tr("Localizable", "setting_push_notification", fallback: "App push notification")
  /// Representative
  internal static let settingRepresentativeTitle = L10n.tr("Localizable", "setting_representative_title", fallback: "Representative")
  /// All your cache will be deleted after you do this action.
  internal static let settingWarningClearCacheDescription = L10n.tr("Localizable", "setting_warning_clear_cache_description", fallback: "All your cache will be deleted after you do this action.")
  /// Are you sure to clear cache data?
  internal static let settingWarningClearCacheTitle = L10n.tr("Localizable", "setting_warning_clear_cache_title", fallback: "Are you sure to clear cache data?")
  /// Do you want to Log out
  internal static let settingWarningLogOutTitle = L10n.tr("Localizable", "setting_warning_log_out_title", fallback: "Do you want to Log out")
  /// Clear all
  internal static let shopClearAll = L10n.tr("Localizable", "shop_clear_all", fallback: "Clear all")
  /// Coupon
  internal static let shopCoupon = L10n.tr("Localizable", "shop_coupon", fallback: "Coupon")
  /// Exchanged Coupons
  internal static let shopExchangedCoupons = L10n.tr("Localizable", "shop_exchanged_coupons", fallback: "Exchanged Coupons")
  /// Coupon
  internal static let shopGift = L10n.tr("Localizable", "shop_gift", fallback: "Coupon")
  /// Got it
  internal static let shopGotIt = L10n.tr("Localizable", "shop_got_it", fallback: "Got it")
  /// You can use Points to exchange Coupons. Then you can bring them to the local stores to get products.
  internal static let shopHelpDescription = L10n.tr("Localizable", "shop_help_description", fallback: "You can use Points to exchange Coupons. Then you can bring them to the local stores to get products.")
  /// Later
  internal static let shopLater = L10n.tr("Localizable", "shop_later", fallback: "Later")
  /// Your order has been completed. Check in Exchanged Coupon.
  internal static let shopOrderGiftSuccess = L10n.tr("Localizable", "shop_order_gift_success", fallback: "Your order has been completed. Check in Exchanged Coupon.")
  /// Search products
  internal static let shopSearchProducts = L10n.tr("Localizable", "shop_search_products", fallback: "Search products")
  /// View all
  internal static let shopViewAll = L10n.tr("Localizable", "shop_view_all", fallback: "View all")
  /// Welcome to NolgoBulja shop!
  internal static let shopWelcomeNoljaShop = L10n.tr("Localizable", "shop_welcome_nolja_shop", fallback: "Welcome to NolgoBulja shop!")
  /// Join the membership
  internal static let signup = L10n.tr("Localizable", "signup", fallback: "Join the membership")
  /// EXPLORE NOW
  internal static let splashExplore = L10n.tr("Localizable", "splash_explore", fallback: "EXPLORE NOW")
  /// Just a moment ...
  internal static let splashWait = L10n.tr("Localizable", "splash_wait", fallback: "Just a moment ...")
  /// Welcome to NolgoBulja. Follow these steps to be our member.
  internal static let splashWelcome = L10n.tr("Localizable", "splash_welcome", fallback: "Welcome to NolgoBulja. Follow these steps to be our member.")
  /// 1588-1588
  internal static let telephoneNumberServiceCenter = L10n.tr("Localizable", "telephone_number_service_center", fallback: "1588-1588")
  /// Agree and Continue
  internal static let tosAgreeAndContinue = L10n.tr("Localizable", "tos_agree_and_continue", fallback: "Agree and Continue")
  /// Compulsory
  internal static let tosCompulsory = L10n.tr("Localizable", "tos_compulsory", fallback: "Compulsory")
  /// tos_compulsory_item_description_1_en
  internal static let tosCompulsoryItemDescription1 = L10n.tr("Localizable", "tos_compulsory_item_description_1", fallback: "tos_compulsory_item_description_1_en")
  /// tos_compulsory_item_description_4_en
  internal static let tosCompulsoryItemDescription4 = L10n.tr("Localizable", "tos_compulsory_item_description_4", fallback: "tos_compulsory_item_description_4_en")
  /// I'm 14 years old older.
  internal static let tosCompulsoryItemTitle1 = L10n.tr("Localizable", "tos_compulsory_item_title_1", fallback: "I'm 14 years old older.")
  /// Terms and Conditions
  internal static let tosCompulsoryItemTitle2 = L10n.tr("Localizable", "tos_compulsory_item_title_2", fallback: "Terms and Conditions")
  /// Comprehensive Terms and Conditions
  internal static let tosCompulsoryItemTitle3 = L10n.tr("Localizable", "tos_compulsory_item_title_3", fallback: "Comprehensive Terms and Conditions")
  /// Collection and Use of Personal Information
  internal static let tosCompulsoryItemTitle4 = L10n.tr("Localizable", "tos_compulsory_item_title_4", fallback: "Collection and Use of Personal Information")
  /// You may choose to agree to the terms individually. 
  /// You may use the service even if you don't agree to the optional terms and conditions
  internal static let tosDescription = L10n.tr("Localizable", "tos_description", fallback: "You may choose to agree to the terms individually. \nYou may use the service even if you don't agree to the optional terms and conditions")
  /// Optional
  internal static let tosOptional = L10n.tr("Localizable", "tos_optional", fallback: "Optional")
  /// Consent to the collection and use of information
  internal static let tosOptionalItemTitle1 = L10n.tr("Localizable", "tos_optional_item_title_1", fallback: "Consent to the collection and use of information")
  /// Collection and Use of Profile Information
  internal static let tosOptionalItemTitle2 = L10n.tr("Localizable", "tos_optional_item_title_2", fallback: "Collection and Use of Profile Information")
  /// I have read and agreed to all terms and conditions
  internal static let tosReadAndAgree = L10n.tr("Localizable", "tos_read_and_agree", fallback: "I have read and agreed to all terms and conditions")
  /// Term of Service
  internal static let tosTitle = L10n.tr("Localizable", "tos_title", fallback: "Term of Service")
  /// Welcome to NolgoBulja. Please read our terms of service carefully.
  internal static let tosWelcome = L10n.tr("Localizable", "tos_welcome", fallback: "Welcome to NolgoBulja. Please read our terms of service carefully.")
  /// Detail Transaction
  internal static let transactionDetail = L10n.tr("Localizable", "transaction_detail", fallback: "Detail Transaction")
  /// Transaction code
  internal static let transactionDetailCode = L10n.tr("Localizable", "transaction_detail_code", fallback: "Transaction code")
  /// Status
  internal static let transactionDetailStatus = L10n.tr("Localizable", "transaction_detail_status", fallback: "Status")
  /// Time
  internal static let transactionDetailTime = L10n.tr("Localizable", "transaction_detail_time", fallback: "Time")
  /// Transaction History
  internal static let transactionHistory = L10n.tr("Localizable", "transaction_history", fallback: "Transaction History")
  /// %@ point
  internal static func transactionHistoryPoint(_ p1: Any) -> String {
    return L10n.tr("Localizable", "transaction_history_point", String(describing: p1), fallback: "%@ point")
  }
  /// Search transaction
  internal static let transactionHistorySearchHint = L10n.tr("Localizable", "transaction_history_search_hint", fallback: "Search transaction")
  /// Receive
  internal static let transactionReceiveType = L10n.tr("Localizable", "transaction_receive_type", fallback: "Receive")
  /// Spent
  internal static let transactionSpentType = L10n.tr("Localizable", "transaction_spent_type", fallback: "Spent")
  /// Receive: %@
  internal static func transactionsHistoryReceiveReason(_ p1: Any) -> String {
    return L10n.tr("Localizable", "transactions_history_receive_reason", String(describing: p1), fallback: "Receive: %@")
  }
  /// Spent: %@
  internal static func transactionsHistorySpentReason(_ p1: Any) -> String {
    return L10n.tr("Localizable", "transactions_history_spent_reason", String(describing: p1), fallback: "Spent: %@")
  }
  /// Uncompleted video
  internal static let uncompletedVideo = L10n.tr("Localizable", "uncompleted_video", fallback: "Uncompleted video")
  /// Set Avatar
  internal static let updateProfileAvatar = L10n.tr("Localizable", "update_profile_avatar", fallback: "Set Avatar")
  /// Open Camera
  internal static let updateProfileAvatarOpenCamera = L10n.tr("Localizable", "update_profile_avatar_open_camera", fallback: "Open Camera")
  /// Select Photo
  internal static let updateProfileAvatarSelectPhoto = L10n.tr("Localizable", "update_profile_avatar_select_photo", fallback: "Select Photo")
  /// Date of Birth
  internal static let updateProfileDateOfBirth = L10n.tr("Localizable", "update_profile_date_of_birth", fallback: "Date of Birth")
  /// Day of Birth
  internal static let updateProfileDob = L10n.tr("Localizable", "update_profile_dob", fallback: "Day of Birth")
  /// Gender
  internal static let updateProfileGender = L10n.tr("Localizable", "update_profile_gender", fallback: "Gender")
  /// Female
  internal static let updateProfileGenderFemale = L10n.tr("Localizable", "update_profile_gender_female", fallback: "Female")
  /// Male
  internal static let updateProfileGenderMale = L10n.tr("Localizable", "update_profile_gender_male", fallback: "Male")
  /// Other
  internal static let updateProfileGenderOther = L10n.tr("Localizable", "update_profile_gender_other", fallback: "Other")
  /// Name
  internal static let updateProfileName = L10n.tr("Localizable", "update_profile_name", fallback: "Name")
  /// This name is invalid
  internal static let updateProfileNameError = L10n.tr("Localizable", "update_profile_name_error", fallback: "This name is invalid")
  /// Required
  internal static let updateProfileNameRequired = L10n.tr("Localizable", "update_profile_name_required", fallback: "Required")
  /// Phone
  internal static let updateProfilePhone = L10n.tr("Localizable", "update_profile_phone", fallback: "Phone")
  /// This phone is invalid
  internal static let updateProfilePhoneError = L10n.tr("Localizable", "update_profile_phone_error", fallback: "This phone is invalid")
  /// User information
  internal static let updateProfileUserInfo = L10n.tr("Localizable", "update_profile_user_info", fallback: "User information")
  /// Complete state: %@ %%
  internal static func videoCompletedState(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_completed_state", String(describing: p1), fallback: "Complete state: %@ %%")
  }
  /// Comments
  internal static let videoDetailComment = L10n.tr("Localizable", "video_detail_comment", fallback: "Comments")
  /// Newest
  internal static let videoDetailCommentNewest = L10n.tr("Localizable", "video_detail_comment_newest", fallback: "Newest")
  /// Popular
  internal static let videoDetailCommentPopular = L10n.tr("Localizable", "video_detail_comment_popular", fallback: "Popular")
  /// %@ days ago
  internal static func videoDetailDurationDays(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_detail_duration_days", String(describing: p1), fallback: "%@ days ago")
  }
  /// %@ hours ago
  internal static func videoDetailDurationHours(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_detail_duration_hours", String(describing: p1), fallback: "%@ hours ago")
  }
  /// just now
  internal static let videoDetailDurationJustNow = L10n.tr("Localizable", "video_detail_duration_just_now", fallback: "just now")
  /// %@ minutes ago
  internal static func videoDetailDurationMinutes(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_detail_duration_minutes", String(describing: p1), fallback: "%@ minutes ago")
  }
  /// %@ months ago
  internal static func videoDetailDurationMonth(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_detail_duration_month", String(describing: p1), fallback: "%@ months ago")
  }
  /// %@ years ago
  internal static func videoDetailDurationYear(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_detail_duration_year", String(describing: p1), fallback: "%@ years ago")
  }
  /// Enter a comment
  internal static let videoDetailEnterComment = L10n.tr("Localizable", "video_detail_enter_comment", fallback: "Enter a comment")
  /// You don't have a youtube account yet.
  internal static let videoDetailNeedYoutubeAccount = L10n.tr("Localizable", "video_detail_need_youtube_account", fallback: "You don't have a youtube account yet.")
  /// To comment on youtube you need an account. Click OK to see the tutorial on how to create youtube.
  internal static let videoDetailNeedYoutubeAccountDescription = L10n.tr("Localizable", "video_detail_need_youtube_account_description", fallback: "To comment on youtube you need an account. Click OK to see the tutorial on how to create youtube.")
  /// You need login google and accept youtube scope to comment or like
  internal static let videoDetailRequireGoogleDescription = L10n.tr("Localizable", "video_detail_require_google_description", fallback: "You need login google and accept youtube scope to comment or like")
  /// Reward
  internal static let videoDetailReward = L10n.tr("Localizable", "video_detail_reward", fallback: "Reward")
  /// %@ point
  internal static func videoDetailRewardPoint(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_detail_reward_point", String(describing: p1), fallback: "%@ point")
  }
  /// %@ · %@ · %@
  internal static func videoDetailShortDescription(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
    return L10n.tr("Localizable", "video_detail_short_description", String(describing: p1), String(describing: p2), String(describing: p3), fallback: "%@ · %@ · %@")
  }
  /// Views
  internal static let videoDetailViews = L10n.tr("Localizable", "video_detail_views", fallback: "Views")
  /// + Earn %@
  internal static func videoEarnPoint(_ p1: Any) -> String {
    return L10n.tr("Localizable", "video_earn_point", String(describing: p1), fallback: "+ Earn %@")
  }
  /// Today features
  internal static let videoListToday = L10n.tr("Localizable", "video_list_today", fallback: "Today features")
  /// Complete watching to reward Points
  internal static let videoListWatchingToGetPoint = L10n.tr("Localizable", "video_list_watching_to_get_point", fallback: "Complete watching to reward Points")
  /// Search video
  internal static let videoSearchVideo = L10n.tr("Localizable", "video_search_video", fallback: "Search video")
  /// Let‘s get points by watching
  internal static let videoTitle = L10n.tr("Localizable", "video_title", fallback: "Let‘s get points by watching")
  /// Accumulated points for the day
  internal static let walletAccumulatedPoint = L10n.tr("Localizable", "wallet_accumulated_point", fallback: "Accumulated points for the day")
  /// Attend now
  internal static let walletAttendNow = L10n.tr("Localizable", "wallet_attend_now", fallback: "Attend now")
  /// Benefit
  internal static let walletBenefit = L10n.tr("Localizable", "wallet_benefit", fallback: "Benefit")
  /// Check in
  internal static let walletCheckin = L10n.tr("Localizable", "wallet_checkin", fallback: "Check in")
  /// Checkin success
  internal static let walletCheckinSuccess = L10n.tr("Localizable", "wallet_checkin_success", fallback: "Checkin success")
  /// Receive
  internal static let walletDashboardReceive = L10n.tr("Localizable", "wallet_dashboard_receive", fallback: "Receive")
  /// Recent transactions
  internal static let walletDashboardRecentTransactions = L10n.tr("Localizable", "wallet_dashboard_recent_transactions", fallback: "Recent transactions")
  /// Spent
  internal static let walletDashboardSpent = L10n.tr("Localizable", "wallet_dashboard_spent", fallback: "Spent")
  /// Dashboard
  internal static let walletDashboardTitle = L10n.tr("Localizable", "wallet_dashboard_title", fallback: "Dashboard")
  /// Everyday
  internal static let walletEveryDay = L10n.tr("Localizable", "wallet_every_day", fallback: "Everyday")
  /// NolgoBulja pays a cashbox every minute
  internal static let walletExchangeDescription = L10n.tr("Localizable", "wallet_exchange_description", fallback: "NolgoBulja pays a cashbox every minute")
  /// Use now
  internal static let walletExchangeMoney = L10n.tr("Localizable", "wallet_exchange_money", fallback: "Use now")
  /// Expected ranking for next month
  internal static let walletExpectNextTier = L10n.tr("Localizable", "wallet_expect_next_tier", fallback: "Expected ranking for next month")
  /// Gold member ship
  internal static let walletGoldMemberShip = L10n.tr("Localizable", "wallet_gold_member_ship", fallback: "Gold member ship")
  /// Dashboard
  internal static let walletHistoryDashboard = L10n.tr("Localizable", "wallet_history_dashboard", fallback: "Dashboard")
  /// My attendance
  internal static let walletMyAttendance = L10n.tr("Localizable", "wallet_my_attendance", fallback: "My attendance")
  /// My Cash
  internal static let walletMyCash = L10n.tr("Localizable", "wallet_my_cash", fallback: "My Cash")
  /// My point
  internal static let walletMyPoint = L10n.tr("Localizable", "wallet_my_point", fallback: "My point")
  /// My Points
  internal static let walletMyPoints = L10n.tr("Localizable", "wallet_my_points", fallback: "My Points")
  /// Friend: %@
  internal static func walletNumberFriends(_ p1: Any) -> String {
    return L10n.tr("Localizable", "wallet_number_friends", String(describing: p1), fallback: "Friend: %@")
  }
  /// Points that can be exchanged
  internal static let walletPointCanExchange = L10n.tr("Localizable", "wallet_point_can_exchange", fallback: "Points that can be exchanged")
  /// Overall Point Ranking: %@
  internal static func walletPointRanking(_ p1: Any) -> String {
    return L10n.tr("Localizable", "wallet_point_ranking", String(describing: p1), fallback: "Overall Point Ranking: %@")
  }
  /// Bronze Membership
  internal static let walletRankingBronze = L10n.tr("Localizable", "wallet_ranking_bronze", fallback: "Bronze Membership")
  /// Gold Membership
  internal static let walletRankingGold = L10n.tr("Localizable", "wallet_ranking_gold", fallback: "Gold Membership")
  /// Premium Membership
  internal static let walletRankingPremium = L10n.tr("Localizable", "wallet_ranking_premium", fallback: "Premium Membership")
  /// Silver Membership
  internal static let walletRankingSilver = L10n.tr("Localizable", "wallet_ranking_silver", fallback: "Silver Membership")
  /// To get
  internal static let walletToGet = L10n.tr("Localizable", "wallet_to_get", fallback: "To get")
  /// View History
  internal static let walletViewHistory = L10n.tr("Localizable", "wallet_view_history", fallback: "View History")
  /// Welcome to NolgoBulja. Watch videos,play and earn.
  internal static let welcomeNoljanolja = L10n.tr("Localizable", "welcome_noljanolja", fallback: "Welcome to NolgoBulja. Watch videos,play and earn.")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
