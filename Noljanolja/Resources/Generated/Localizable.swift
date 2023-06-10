// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// This phone number is not available.
  internal static let addFriendPhoneNotAvailable = L10n.tr("Localizable", "add_friend_phone_not_available", fallback: "This phone number is not available.")
  /// Scan this QR code to add me
  internal static let addFriendsAddByContactDescription = L10n.tr("Localizable", "add_friends_add_by_contact_description", fallback: "Scan this QR code to add me")
  /// Add by contacts
  internal static let addFriendsAddByContactTitle = L10n.tr("Localizable", "add_friends_add_by_contact_title", fallback: "Add by contacts")
  /// Chat now
  internal static let addFriendsChatNow = L10n.tr("Localizable", "add_friends_chat_now", fallback: "Chat now")
  /// Scan QR code
  internal static let addFriendsScanQrCode = L10n.tr("Localizable", "add_friends_scan_qr_code", fallback: "Scan QR code")
  /// Enter phone number
  internal static let addFriendsSearchPhoneHint = L10n.tr("Localizable", "add_friends_search_phone_hint", fallback: "Enter phone number")
  /// Add Friends
  internal static let addFriendsTitle = L10n.tr("Localizable", "add_friends_title", fallback: "Add Friends")
  /// %@ selected
  internal static func argsChatSelected(_ p1: Any) -> String {
    return L10n.tr("Localizable", "args_chat_selected", String(describing: p1), fallback: "%@ selected")
  }
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
  /// Welcome to Noja Noja. Follow these steps to be our member.
  internal static let authWelcome = L10n.tr("Localizable", "auth_welcome", fallback: "Welcome to Noja Noja. Follow these steps to be our member.")
  /// Change Password
  internal static let changePassword = L10n.tr("Localizable", "change_password", fallback: "Change Password")
  /// Album
  internal static let chatActionAlbum = L10n.tr("Localizable", "chat_action_album", fallback: "Album")
  /// Camera
  internal static let chatActionCamera = L10n.tr("Localizable", "chat_action_camera", fallback: "Camera")
  /// Contacts
  internal static let chatActionContacts = L10n.tr("Localizable", "chat_action_contacts", fallback: "Contacts")
  /// Events
  internal static let chatActionEvents = L10n.tr("Localizable", "chat_action_events", fallback: "Events")
  /// File
  internal static let chatActionFile = L10n.tr("Localizable", "chat_action_file", fallback: "File")
  /// Location
  internal static let chatActionLocation = L10n.tr("Localizable", "chat_action_location", fallback: "Location")
  /// Voice chat
  internal static let chatActionVoiceChat = L10n.tr("Localizable", "chat_action_voice_chat", fallback: "Voice chat")
  /// Wallet
  internal static let chatActionWallet = L10n.tr("Localizable", "chat_action_wallet", fallback: "Wallet")
  /// Record a video
  internal static let chatCameraRecordVideo = L10n.tr("Localizable", "chat_camera_record_video", fallback: "Record a video")
  /// Take a photo
  internal static let chatCameraTakePhoto = L10n.tr("Localizable", "chat_camera_take_photo", fallback: "Take a photo")
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
  /// Close
  internal static let commonClose = L10n.tr("Localizable", "common_close", fallback: "Close")
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
  /// Friends
  internal static let commonFriends = L10n.tr("Localizable", "common_friends", fallback: "Friends")
  /// Id
  internal static let commonId = L10n.tr("Localizable", "common_id", fallback: "Id")
  /// Loading...
  internal static let commonLoading = L10n.tr("Localizable", "common_loading", fallback: "Loading...")
  /// Log out
  internal static let commonLogOut = L10n.tr("Localizable", "common_log_out", fallback: "Log out")
  /// Log in
  internal static let commonLogin = L10n.tr("Localizable", "common_login", fallback: "Log in")
  /// Members
  internal static let commonMembers = L10n.tr("Localizable", "common_members", fallback: "Members")
  /// Next
  internal static let commonNext = L10n.tr("Localizable", "common_next", fallback: "Next")
  /// No
  internal static let commonNo = L10n.tr("Localizable", "common_no", fallback: "No")
  /// OK
  internal static let commonOk = L10n.tr("Localizable", "common_ok", fallback: "OK")
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
  /// Setting
  internal static let commonSetting = L10n.tr("Localizable", "common_setting", fallback: "Setting")
  /// Size %@
  internal static func commonSize(_ p1: Any) -> String {
    return L10n.tr("Localizable", "common_size", String(describing: p1), fallback: "Size %@")
  }
  /// Skip
  internal static let commonSkip = L10n.tr("Localizable", "common_skip", fallback: "Skip")
  /// Success
  internal static let commonSuccess = L10n.tr("Localizable", "common_success", fallback: "Success")
  /// Today
  internal static let commonToday = L10n.tr("Localizable", "common_today", fallback: "Today")
  /// Try again
  internal static let commonTryAgain = L10n.tr("Localizable", "common_try_again", fallback: "Try again")
  /// Unexpected Error
  internal static let commonUnexpectedError = L10n.tr("Localizable", "common_unexpected_error", fallback: "Unexpected Error")
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
  /// No contacts found
  internal static let contactsNotFound = L10n.tr("Localizable", "contacts_not_found", fallback: "No contacts found")
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
  /// Change Chat room's name
  internal static let editChatChangeRoomName = L10n.tr("Localizable", "edit_chat_change_room_name", fallback: "Change Chat room's name")
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
  /// Exchange Account Management
  internal static let exchangeAccountManagement = L10n.tr("Localizable", "exchange_account_management", fallback: "Exchange Account Management")
  /// Forgot your password?
  internal static let forgotPassword = L10n.tr("Localizable", "forgot_password", fallback: "Forgot your password?")
  /// Full agreement
  internal static let fullAgreement = L10n.tr("Localizable", "full_agreement", fallback: "Full agreement")
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
  /// Email is not valid
  internal static let invalidEmailFormat = L10n.tr("Localizable", "invalid_email_format", fallback: "Email is not valid")
  /// You will receive a code to verify to this phone number via text message.
  internal static let loginConfirmPhoneDescription = L10n.tr("Localizable", "login_confirm_phone_description", fallback: "You will receive a code to verify to this phone number via text message.")
  /// Country
  internal static let loginCountryInputLabel = L10n.tr("Localizable", "login_country_input_label", fallback: "Country")
  /// Please input the correct phone number since this number will be used to verify your account.
  internal static let loginInvalidPhoneDescription = L10n.tr("Localizable", "login_invalid_phone_description", fallback: "Please input the correct phone number since this number will be used to verify your account.")
  /// Incorrect Number
  internal static let loginInvalidPhoneTitle = L10n.tr("Localizable", "login_invalid_phone_title", fallback: "Incorrect Number")
  /// Welcome to Nolja Nolja. Please enter your Phone number to join continue.
  internal static let loginPhoneDescription = L10n.tr("Localizable", "login_phone_description", fallback: "Welcome to Nolja Nolja. Please enter your Phone number to join continue.")
  /// Phone Number
  internal static let loginPhoneInputLabel = L10n.tr("Localizable", "login_phone_input_label", fallback: "Phone Number")
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
  /// My Info
  internal static let myInfo = L10n.tr("Localizable", "my_info", fallback: "My Info")
  /// My Page
  internal static let myPage = L10n.tr("Localizable", "my_page", fallback: "My Page")
  /// My ranking
  internal static let myRankingTitle = L10n.tr("Localizable", "my_ranking_title", fallback: "My ranking")
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
  /// To help you access gallery on Noljanolja, allow Noljanolja access to your media files.
  internal static let permissionAccessStorageDescription = L10n.tr("Localizable", "permission_access_storage_description", fallback: "To help you access gallery on Noljanolja, allow Noljanolja access to your media files.")
  /// To help you message friends and family on Noljanolja, allow Noljanolja access to your contacts.
  internal static let permissionContactsDescription = L10n.tr("Localizable", "permission_contacts_description", fallback: "To help you message friends and family on Noljanolja, allow Noljanolja access to your contacts.")
  /// Go to setting
  internal static let permissionGoToSettings = L10n.tr("Localizable", "permission_go_to_settings", fallback: "Go to setting")
  /// Permit Nolja Nolja to send you notification in order to
  /// conect with your friends.
  internal static let permissionNotificationDescription = L10n.tr("Localizable", "permission_notification_description", fallback: "Permit Nolja Nolja to send you notification in order to\nconect with your friends.")
  /// Turn on notification
  /// for Nolja Nolja
  internal static let permissionNotificationTitle = L10n.tr("Localizable", "permission_notification_title", fallback: "Turn on notification\nfor Nolja Nolja")
  /// You're unable to use this feature without the required permissions. 
  /// Tap the Settings button to allow Noljanolja to access the required permission.
  internal static let permissionRequiredDescription = L10n.tr("Localizable", "permission_required_description", fallback: "You're unable to use this feature without the required permissions. \nTap the Settings button to allow Noljanolja to access the required permission.")
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
  /// Join the membership
  internal static let signup = L10n.tr("Localizable", "signup", fallback: "Join the membership")
  /// EXPLORE NOW
  internal static let splashExplore = L10n.tr("Localizable", "splash_explore", fallback: "EXPLORE NOW")
  /// Just a moment ...
  internal static let splashWait = L10n.tr("Localizable", "splash_wait", fallback: "Just a moment ...")
  /// Welcome to Noja Noja. Follow these steps to be our member.
  internal static let splashWelcome = L10n.tr("Localizable", "splash_welcome", fallback: "Welcome to Noja Noja. Follow these steps to be our member.")
  /// 1588-1588
  internal static let telephoneNumberServiceCenter = L10n.tr("Localizable", "telephone_number_service_center", fallback: "1588-1588")
  /// Agree and Continue
  internal static let tosAgreeAndContinue = L10n.tr("Localizable", "tos_agree_and_continue", fallback: "Agree and Continue")
  /// Compulsory
  internal static let tosCompulsory = L10n.tr("Localizable", "tos_compulsory", fallback: "Compulsory")
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
  /// Terms of service
  internal static let tosTitle = L10n.tr("Localizable", "tos_title", fallback: "Terms of service")
  /// Welcome to Nolja Nolja. Please read our terms of service carefully.
  internal static let tosWelcome = L10n.tr("Localizable", "tos_welcome", fallback: "Welcome to Nolja Nolja. Please read our terms of service carefully.")
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
  /// Required
  internal static let updateProfileNameRequired = L10n.tr("Localizable", "update_profile_name_required", fallback: "Required")
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
  /// Today features
  internal static let videoListToday = L10n.tr("Localizable", "video_list_today", fallback: "Today features")
  /// Complete watching to reward Points
  internal static let videoListWatchingToGetPoint = L10n.tr("Localizable", "video_list_watching_to_get_point", fallback: "Complete watching to reward Points")
  /// Let's get points by watching
  internal static let videoTitle = L10n.tr("Localizable", "video_title", fallback: "Let's get points by watching")
  /// Accumulated points for the day
  internal static let walletAccumulatedPoint = L10n.tr("Localizable", "wallet_accumulated_point", fallback: "Accumulated points for the day")
  /// Attend now
  internal static let walletAttendNow = L10n.tr("Localizable", "wallet_attend_now", fallback: "Attend now")
  /// Receive
  internal static let walletDashboardReceive = L10n.tr("Localizable", "wallet_dashboard_receive", fallback: "Receive")
  /// Recent transactions
  internal static let walletDashboardRecentTransactions = L10n.tr("Localizable", "wallet_dashboard_recent_transactions", fallback: "Recent transactions")
  /// Spent
  internal static let walletDashboardSpent = L10n.tr("Localizable", "wallet_dashboard_spent", fallback: "Spent")
  /// Dashboard
  internal static let walletDashboardTitle = L10n.tr("Localizable", "wallet_dashboard_title", fallback: "Dashboard")
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
  /// My point
  internal static let walletMyPoint = L10n.tr("Localizable", "wallet_my_point", fallback: "My point")
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
  /// View History
  internal static let walletViewHistory = L10n.tr("Localizable", "wallet_view_history", fallback: "View History")
  /// Welcome to Noja Noja. Watch videos,play and earn.
  internal static let welcomeNoljanolja = L10n.tr("Localizable", "welcome_noljanolja", fallback: "Welcome to Noja Noja. Watch videos,play and earn.")
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
