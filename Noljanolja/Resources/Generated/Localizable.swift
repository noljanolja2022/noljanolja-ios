// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Permission
  internal static let permission = L10n.tr("Localizable", "permission", fallback: "Permission")
  /// Join the membership
  internal static let signup = L10n.tr("Localizable", "signup", fallback: "Join the membership")
  internal enum Args {
    internal enum Chat {
      /// %d selected
      internal static func selected(_ p1: Int) -> String {
        return L10n.tr("Localizable", "args.chat.selected", p1, fallback: "%d selected")
      }
    }
  }
  internal enum Auth {
    internal enum Email {
      /// Email verification
      internal static let verification = L10n.tr("Localizable", "auth.email.verification", fallback: "Email verification")
      internal enum Verification {
        /// Identity verification complete!
        internal static let complete = L10n.tr("Localizable", "auth.email.verification.complete", fallback: "Identity verification complete!")
      }
    }
    internal enum Find {
      /// Find Email
      internal static let email = L10n.tr("Localizable", "auth.find.email", fallback: "Find Email")
      /// Find password
      internal static let password = L10n.tr("Localizable", "auth.find.password", fallback: "Find password")
    }
    internal enum Forgot {
      /// Find Password
      internal static let title = L10n.tr("Localizable", "auth.forgot.title", fallback: "Find Password")
    }
    internal enum Identity {
      /// Identity verification complete!
      internal static let complete = L10n.tr("Localizable", "auth.identity.complete", fallback: "Identity verification complete!")
    }
    internal enum Login {
      internal enum New {
        /// Please log in with your temporary password
        /// and change your password.
        internal static let password = L10n.tr("Localizable", "auth.login.new.password", fallback: "Please log in with your temporary password\nand change your password.")
      }
      internal enum With {
        /// Login with SNS
        internal static let sns = L10n.tr("Localizable", "auth.login.with.SNS", fallback: "Login with SNS")
      }
    }
    internal enum Need {
      internal enum Agreement {
        /// You need to agree to the terms and conditions before signing up
        internal static let terms = L10n.tr("Localizable", "auth.need.agreement.terms", fallback: "You need to agree to the terms and conditions before signing up")
      }
    }
    internal enum Resend {
      /// Resend temporary password
      internal static let password = L10n.tr("Localizable", "auth.resend.password", fallback: "Resend temporary password")
    }
    internal enum Reset {
      internal enum Email {
        /// Temporary password to your email
        /// has been sent
        internal static let sended = L10n.tr("Localizable", "auth.reset.email.sended", fallback: "Temporary password to your email\nhas been sent")
      }
    }
    internal enum Signup {
      /// Step 1
      internal static let step1 = L10n.tr("Localizable", "auth.signup.step1", fallback: "Step 1")
      /// Step 2
      internal static let step2 = L10n.tr("Localizable", "auth.signup.step2", fallback: "Step 2")
      /// Step 3
      internal static let step3 = L10n.tr("Localizable", "auth.signup.step3", fallback: "Step 3")
      internal enum With {
        /// Signup with email and password
        internal static let email = L10n.tr("Localizable", "auth.signup.with.email", fallback: "Signup with email and password")
      }
    }
    internal enum Verify {
      internal enum Email {
        /// Verify email to finish
        internal static let finish = L10n.tr("Localizable", "auth.verify.email.finish", fallback: "Verify email to finish")
      }
    }
  }
  internal enum Change {
    /// Change Password
    internal static let password = L10n.tr("Localizable", "change.password", fallback: "Change Password")
  }
  internal enum Chat {
    internal enum Action {
      /// Album
      internal static let album = L10n.tr("Localizable", "chat.action.album", fallback: "Album")
      /// Camera
      internal static let camera = L10n.tr("Localizable", "chat.action.camera", fallback: "Camera")
      /// Contacts
      internal static let contacts = L10n.tr("Localizable", "chat.action.contacts", fallback: "Contacts")
      /// Events
      internal static let events = L10n.tr("Localizable", "chat.action.events", fallback: "Events")
      /// File
      internal static let file = L10n.tr("Localizable", "chat.action.file", fallback: "File")
      /// Location
      internal static let location = L10n.tr("Localizable", "chat.action.location", fallback: "Location")
      /// Wallet
      internal static let wallet = L10n.tr("Localizable", "chat.action.wallet", fallback: "Wallet")
      internal enum Voice {
        /// Voice chat
        internal static let chat = L10n.tr("Localizable", "chat.action.voice.chat", fallback: "Voice chat")
      }
    }
    internal enum Camera {
      internal enum Record {
        /// Record a video
        internal static let video = L10n.tr("Localizable", "chat.camera.record.video", fallback: "Record a video")
      }
      internal enum Take {
        /// Take a photo
        internal static let photo = L10n.tr("Localizable", "chat.camera.take.photo", fallback: "Take a photo")
      }
    }
    internal enum Input {
      /// Aa
      internal static let hint = L10n.tr("Localizable", "chat.input.hint", fallback: "Aa")
    }
    internal enum Message {
      internal enum Event {
        /// %s has invited %s
        internal static func joined(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "chat.message.event.joined", p1, p2, fallback: "%s has invited %s")
        }
        /// %s has left the conversation
        internal static func `left`(_ p1: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "chat.message.event.left", p1, fallback: "%s has left the conversation")
        }
        /// %s has updated conversation %s
        internal static func updated(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "chat.message.event.updated", p1, p2, fallback: "%s has updated conversation %s")
        }
      }
    }
    internal enum Removed {
      /// You has removed from conversation %s
      internal static func conversation(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "chat.removed.conversation", p1, fallback: "You has removed from conversation %s")
      }
    }
  }
  internal enum Chats {
    /// Chats
    internal static let title = L10n.tr("Localizable", "chats.title", fallback: "Chats")
    internal enum Message {
      /// You received a file
      internal static let file = L10n.tr("Localizable", "chats.message.file", fallback: "You received a file")
      /// You received a photo
      internal static let photo = L10n.tr("Localizable", "chats.message.photo", fallback: "You received a photo")
      /// You received a sticker
      internal static let sticker = L10n.tr("Localizable", "chats.message.sticker", fallback: "You received a sticker")
      /// You received a message
      internal static let unknown = L10n.tr("Localizable", "chats.message.unknown", fallback: "You received a message")
      /// You received a video
      internal static let video = L10n.tr("Localizable", "chats.message.video", fallback: "You received a video")
      internal enum My {
        /// You sent a file
        internal static let file = L10n.tr("Localizable", "chats.message.my.file", fallback: "You sent a file")
        /// You sent a photo
        internal static let photo = L10n.tr("Localizable", "chats.message.my.photo", fallback: "You sent a photo")
        /// You sent a sticker
        internal static let sticker = L10n.tr("Localizable", "chats.message.my.sticker", fallback: "You sent a sticker")
        /// You sent a message
        internal static let unknown = L10n.tr("Localizable", "chats.message.my.unknown", fallback: "You sent a message")
        /// You sent a video
        internal static let video = L10n.tr("Localizable", "chats.message.my.video", fallback: "You sent a video")
      }
    }
    internal enum New {
      /// New Chat
      internal static let chat = L10n.tr("Localizable", "chats.new.chat", fallback: "New Chat")
    }
  }
  internal enum Common {
    /// Admin
    internal static let admin = L10n.tr("Localizable", "common.admin", fallback: "Admin")
    /// Agree
    internal static let agree = L10n.tr("Localizable", "common.agree", fallback: "Agree")
    /// All
    internal static let all = L10n.tr("Localizable", "common.all", fallback: "All")
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "common.cancel", fallback: "Cancel")
    /// Chat
    internal static let chat = L10n.tr("Localizable", "common.chat", fallback: "Chat")
    /// Confirm
    internal static let confirm = L10n.tr("Localizable", "common.confirm", fallback: "Confirm")
    /// Continue
    internal static let `continue` = L10n.tr("Localizable", "common.continue", fallback: "Continue")
    /// Copy
    internal static let copy = L10n.tr("Localizable", "common.copy", fallback: "Copy")
    /// Disagree
    internal static let disagree = L10n.tr("Localizable", "common.disagree", fallback: "Disagree")
    /// Download
    internal static let download = L10n.tr("Localizable", "common.download", fallback: "Download")
    /// Friends
    internal static let friends = L10n.tr("Localizable", "common.friends", fallback: "Friends")
    /// Id
    internal static let id = L10n.tr("Localizable", "common.id", fallback: "Id")
    /// Loading...
    internal static let loading = L10n.tr("Localizable", "common.loading", fallback: "Loading...")
    /// Log in
    internal static let login = L10n.tr("Localizable", "common.login", fallback: "Log in")
    /// Members
    internal static let members = L10n.tr("Localizable", "common.members", fallback: "Members")
    /// Next
    internal static let next = L10n.tr("Localizable", "common.next", fallback: "Next")
    /// OK
    internal static let ok = L10n.tr("Localizable", "common.ok", fallback: "OK")
    /// Previous
    internal static let previous = L10n.tr("Localizable", "common.previous", fallback: "Previous")
    /// Reload
    internal static let reload = L10n.tr("Localizable", "common.reload", fallback: "Reload")
    /// Save
    internal static let save = L10n.tr("Localizable", "common.save", fallback: "Save")
    /// Search
    internal static let search = L10n.tr("Localizable", "common.search", fallback: "Search")
    /// Setting
    internal static let setting = L10n.tr("Localizable", "common.setting", fallback: "Setting")
    /// Size %s
    internal static func size(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "common.size", p1, fallback: "Size %s")
    }
    /// Skip
    internal static let skip = L10n.tr("Localizable", "common.skip", fallback: "Skip")
    /// Today
    internal static let today = L10n.tr("Localizable", "common.today", fallback: "Today")
    /// Verification
    internal static let verification = L10n.tr("Localizable", "common.verification", fallback: "Verification")
    /// Warning
    internal static let warning = L10n.tr("Localizable", "common.warning", fallback: "Warning")
    /// Withdrawal
    internal static let withdrwal = L10n.tr("Localizable", "common.withdrwal", fallback: "Withdrawal")
    /// Yesterday
    internal static let yesterday = L10n.tr("Localizable", "common.yesterday", fallback: "Yesterday")
    /// You
    internal static let you = L10n.tr("Localizable", "common.you", fallback: "You")
    internal enum Copy {
      /// Copied in clipboard
      internal static let success = L10n.tr("Localizable", "common.copy.success", fallback: "Copied in clipboard")
    }
    internal enum Error {
      /// An unexpected error has occurred. Please try again.
      internal static let description = L10n.tr("Localizable", "common.error.description", fallback: "An unexpected error has occurred. Please try again.")
      /// Error
      internal static let title = L10n.tr("Localizable", "common.error.title", fallback: "Error")
    }
    internal enum Log {
      /// Log out
      internal static let out = L10n.tr("Localizable", "common.log.out", fallback: "Log out")
    }
    internal enum Unexpected {
      /// Unexpected Error
      internal static let error = L10n.tr("Localizable", "common.unexpected.error", fallback: "Unexpected Error")
    }
  }
  internal enum Confirm {
    internal enum Password {
      internal enum Hint {
        /// Please enter your confirm password
        internal static let text = L10n.tr("Localizable", "confirm.password.hint.text", fallback: "Please enter your confirm password")
      }
    }
  }
  internal enum Contacts {
    internal enum Not {
      /// No contacts found
      internal static let found = L10n.tr("Localizable", "contacts.not.found", fallback: "No contacts found")
    }
    internal enum Start {
      /// Start Chatting
      internal static let chat = L10n.tr("Localizable", "contacts.start.chat", fallback: "Start Chatting")
    }
    internal enum Title {
      /// Group chat
      internal static let group = L10n.tr("Localizable", "contacts.title.group", fallback: "Group chat")
      /// Normal chat
      internal static let normal = L10n.tr("Localizable", "contacts.title.normal", fallback: "Normal chat")
      /// Secret chat
      internal static let secret = L10n.tr("Localizable", "contacts.title.secret", fallback: "Secret chat")
      internal enum Add {
        /// Add members
        internal static let memmber = L10n.tr("Localizable", "contacts.title.add.memmber", fallback: "Add members")
      }
    }
  }
  internal enum Conversation {
    /// %s created conversation
    internal static func create(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "conversation.create", p1, fallback: "%s created conversation")
    }
    /// Add friends to chat now.
    internal static let empty = L10n.tr("Localizable", "conversation.empty", fallback: "Add friends to chat now.")
    internal enum Has {
      /// Conversation has changed
      internal static let changed = L10n.tr("Localizable", "conversation.has.changed", fallback: "Conversation has changed")
    }
  }
  internal enum Countries {
    /// Search
    internal static let search = L10n.tr("Localizable", "countries.search", fallback: "Search")
    /// Select countries/regions
    internal static let title = L10n.tr("Localizable", "countries.title", fallback: "Select countries/regions")
  }
  internal enum Custom {
    internal enum Service {
      /// Custom service center
      internal static let center = L10n.tr("Localizable", "custom.service.center", fallback: "Custom service center")
    }
  }
  internal enum Edit {
    internal enum Chat {
      internal enum Add {
        /// Add members
        internal static let members = L10n.tr("Localizable", "edit.chat.add.members", fallback: "Add members")
      }
      internal enum Block {
        /// Block user
        internal static let user = L10n.tr("Localizable", "edit.chat.block.user", fallback: "Block user")
      }
      internal enum Change {
        internal enum Room {
          /// Change Chat roomâ€™s name
          internal static let name = L10n.tr("Localizable", "edit.chat.change.room.name", fallback: "Change Chat roomâ€™s name")
        }
      }
      internal enum Leave {
        /// Leave chat room
        internal static let chat = L10n.tr("Localizable", "edit.chat.leave.chat", fallback: "Leave chat room")
      }
      internal enum Make {
        /// Make admin
        internal static let admin = L10n.tr("Localizable", "edit.chat.make.admin", fallback: "Make admin")
      }
      internal enum Remove {
        /// Remove user
        internal static let user = L10n.tr("Localizable", "edit.chat.remove.user", fallback: "Remove user")
      }
      internal enum Warning {
        internal enum Admin {
          /// This user will be assigned to admin for this chat.
          internal static let description = L10n.tr("Localizable", "edit.chat.warning.admin.description", fallback: "This user will be assigned to admin for this chat.")
          /// Are you sure to assign admin this user?
          internal static let title = L10n.tr("Localizable", "edit.chat.warning.admin.title", fallback: "Are you sure to assign admin this user?")
        }
        internal enum Block {
          /// This user will be blocked to send or receive message with you.
          internal static let description = L10n.tr("Localizable", "edit.chat.warning.block.description", fallback: "This user will be blocked to send or receive message with you.")
          /// Are you sure to block this user?
          internal static let title = L10n.tr("Localizable", "edit.chat.warning.block.title", fallback: "Are you sure to block this user?")
        }
        internal enum Leave {
          /// If you leave, all the chat and chat history will be deleted.
          internal static let description = L10n.tr("Localizable", "edit.chat.warning.leave.description", fallback: "If you leave, all the chat and chat history will be deleted.")
          /// Are you sure to leave this chat?
          internal static let title = L10n.tr("Localizable", "edit.chat.warning.leave.title", fallback: "Are you sure to leave this chat?")
        }
        internal enum Remove {
          /// This user will be removed from this chat.
          internal static let description = L10n.tr("Localizable", "edit.chat.warning.remove.description", fallback: "This user will be removed from this chat.")
          /// Are you sure to remove this user?
          internal static let title = L10n.tr("Localizable", "edit.chat.warning.remove.title", fallback: "Are you sure to remove this user?")
        }
      }
    }
    internal enum Member {
      /// Edit member infomation
      internal static let infomation = L10n.tr("Localizable", "edit.member.infomation", fallback: "Edit member infomation")
    }
  }
  internal enum Email {
    internal enum Hint {
      /// Please enter your email
      internal static let text = L10n.tr("Localizable", "email.hint.text", fallback: "Please enter your email")
    }
  }
  internal enum Exchange {
    internal enum Account {
      /// Exchange Account Management
      internal static let management = L10n.tr("Localizable", "exchange.account.management", fallback: "Exchange Account Management")
    }
  }
  internal enum Forgot {
    /// Forgot your password?
    internal static let password = L10n.tr("Localizable", "forgot.password", fallback: "Forgot your password?")
  }
  internal enum Full {
    /// Full agreement
    internal static let agreement = L10n.tr("Localizable", "full.agreement", fallback: "Full agreement")
  }
  internal enum Hello {
    /// Hello %s
    internal static func user(_ p1: UnsafePointer<CChar>) -> String {
      return L10n.tr("Localizable", "hello.user", p1, fallback: "Hello %s")
    }
  }
  internal enum Home {
    /// Chats
    internal static let chats = L10n.tr("Localizable", "home.chats", fallback: "Chats")
    /// News
    internal static let news = L10n.tr("Localizable", "home.news", fallback: "News")
    /// Shop
    internal static let shop = L10n.tr("Localizable", "home.shop", fallback: "Shop")
    /// Wallet
    internal static let wallet = L10n.tr("Localizable", "home.wallet", fallback: "Wallet")
    /// Watch
    internal static let watch = L10n.tr("Localizable", "home.watch", fallback: "Watch")
  }
  internal enum Invalid {
    internal enum Email {
      /// Email is not valid
      internal static let format = L10n.tr("Localizable", "invalid.email.format", fallback: "Email is not valid")
    }
  }
  internal enum Login {
    internal enum Confirm {
      internal enum Phone {
        /// You will receive a code to verify to this phone number via text message.
        internal static let description = L10n.tr("Localizable", "login.confirm.phone.description", fallback: "You will receive a code to verify to this phone number via text message.")
      }
    }
    internal enum Country {
      internal enum Input {
        /// Country
        internal static let label = L10n.tr("Localizable", "login.country.input.label", fallback: "Country")
      }
    }
    internal enum Invalid {
      internal enum Phone {
        /// Please input the correct phone number since this number will be used to verify your account.
        internal static let description = L10n.tr("Localizable", "login.invalid.phone.description", fallback: "Please input the correct phone number since this number will be used to verify your account.")
        /// Incorrect Number
        internal static let title = L10n.tr("Localizable", "login.invalid.phone.title", fallback: "Incorrect Number")
      }
    }
    internal enum Phone {
      /// Welcome to Nolja Nolja. Please enter your Phone number to join continue.
      internal static let description = L10n.tr("Localizable", "login.phone.description", fallback: "Welcome to Nolja Nolja. Please enter your Phone number to join continue.")
      internal enum Input {
        /// Phone Number
        internal static let label = L10n.tr("Localizable", "login.phone.input.label", fallback: "Phone Number")
      }
    }
  }
  internal enum Menu {
    /// Announcement
    internal static let announcement = L10n.tr("Localizable", "menu.announcement", fallback: "Announcement")
    /// Menu
    internal static let title = L10n.tr("Localizable", "menu.title", fallback: "Menu")
    internal enum Checkout {
      internal enum And {
        /// Check out and play
        internal static let play = L10n.tr("Localizable", "menu.checkout.and.play", fallback: "Check out and play")
      }
    }
    internal enum Exchange {
      /// Exchanging money
      internal static let money = L10n.tr("Localizable", "menu.exchange.money", fallback: "Exchanging money")
    }
    internal enum Join {
      internal enum And {
        /// Let's join and play
        internal static let play = L10n.tr("Localizable", "menu.join.and.play", fallback: "Let's join and play")
      }
    }
    internal enum Play {
      /// Let's play while watching the video
      internal static let video = L10n.tr("Localizable", "menu.play.video", fallback: "Let's play while watching the video")
    }
    internal enum Point {
      /// Point details
      internal static let details = L10n.tr("Localizable", "menu.point.details", fallback: "Point details")
    }
  }
  internal enum My {
    /// My Info
    internal static let info = L10n.tr("Localizable", "my.info", fallback: "My Info")
    /// My Page
    internal static let page = L10n.tr("Localizable", "my.page", fallback: "My Page")
    internal enum Ranking {
      /// My ranking
      internal static let title = L10n.tr("Localizable", "my.ranking.title", fallback: "My ranking")
    }
  }
  internal enum Otp {
    /// We've sent a text message with your verification code to
    internal static let description = L10n.tr("Localizable", "otp.description", fallback: "We've sent a text message with your verification code to")
    /// Enter verification code
    internal static let title = L10n.tr("Localizable", "otp.title", fallback: "Enter verification code")
    /// Verifying...
    internal static let verifying = L10n.tr("Localizable", "otp.verifying", fallback: "Verifying...")
    internal enum Invalid {
      internal enum Otp {
        /// Please make sure you input the correct code received via messages.
        internal static let description = L10n.tr("Localizable", "otp.invalid.otp.description", fallback: "Please make sure you input the correct code received via messages.")
        /// Incorrect Code
        internal static let title = L10n.tr("Localizable", "otp.invalid.otp.title", fallback: "Incorrect Code")
      }
    }
    internal enum Resend {
      /// Resend Code
      internal static let code = L10n.tr("Localizable", "otp.resend.code", fallback: "Resend Code")
      internal enum Code {
        /// Resend code in %s seconds
        internal static func waiting(_ p1: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "otp.resend.code.waiting", p1, fallback: "Resend code in %s seconds")
        }
      }
    }
  }
  internal enum Password {
    internal enum Hint {
      /// Please enter your password
      internal static let text = L10n.tr("Localizable", "password.hint.text", fallback: "Please enter your password")
    }
  }
  internal enum Permission {
    /// Accept
    internal static let accept = L10n.tr("Localizable", "permission.accept", fallback: "Accept")
    internal enum Access {
      internal enum Storage {
        /// To help you access gallery on Noljanolja, allow Noljanolja access to your media files.
        internal static let description = L10n.tr("Localizable", "permission.access.storage.description", fallback: "To help you access gallery on Noljanolja, allow Noljanolja access to your media files.")
      }
    }
    internal enum Contacts {
      /// To help you message friends and family on Noljanolja, allow Noljanolja access to your contacts.
      internal static let description = L10n.tr("Localizable", "permission.contacts.description", fallback: "To help you message friends and family on Noljanolja, allow Noljanolja access to your contacts.")
    }
    internal enum Go {
      internal enum To {
        /// Settings
        internal static let settings = L10n.tr("Localizable", "permission.go.to.settings", fallback: "Settings")
      }
    }
    internal enum Required {
      /// You're unable to use this feature without the required permissions. 
      /// Tap the Settings button to allow Noljanolja to access the required permission.
      internal static let description = L10n.tr("Localizable", "permission.required.description", fallback: "You're unable to use this feature without the required permissions. \nTap the Settings button to allow Noljanolja to access the required permission.")
    }
  }
  internal enum Require {
    internal enum Login {
      /// Let's Play Log in
      internal static let button = L10n.tr("Localizable", "require.login.button", fallback: "Let's Play Log in")
      /// Log in to play
      /// Use a variety of services!
      internal static let description = L10n.tr("Localizable", "require.login.description", fallback: "Log in to play\nUse a variety of services!")
      /// Let's Play Start the service
      internal static let title = L10n.tr("Localizable", "require.login.title", fallback: "Let's Play Start the service")
    }
    internal enum Verify {
      /// Verify Email
      internal static let button = L10n.tr("Localizable", "require.verify.button", fallback: "Verify Email")
      /// Verify email to play
      /// Use a variety of services
      internal static let description = L10n.tr("Localizable", "require.verify.description", fallback: "Verify email to play\nUse a variety of services")
    }
  }
  internal enum Service {
    /// Service Guide
    internal static let guide = L10n.tr("Localizable", "service.guide", fallback: "Service Guide")
  }
  internal enum Setting {
    /// FAQ
    internal static let faq = L10n.tr("Localizable", "setting.faq", fallback: "FAQ")
    /// Name
    internal static let name = L10n.tr("Localizable", "setting.name", fallback: "Name")
    internal enum Clear {
      internal enum Cache {
        /// Clear cache data
        internal static let data = L10n.tr("Localizable", "setting.clear.cache.data", fallback: "Clear cache data")
      }
    }
    internal enum Current {
      /// Current version %s
      internal static func version(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "setting.current.version", p1, fallback: "Current version %s")
      }
    }
    internal enum Exchange {
      internal enum Account {
        /// Exchange account management
        internal static let management = L10n.tr("Localizable", "setting.exchange.account.management", fallback: "Exchange account management")
      }
    }
    internal enum Open {
      internal enum Source {
        /// Open source license
        internal static let licence = L10n.tr("Localizable", "setting.open.source.licence", fallback: "Open source license")
        /// Open source license
        internal static let license = L10n.tr("Localizable", "setting.open.source.license", fallback: "Open source license")
      }
    }
    internal enum Phone {
      /// Phone number
      internal static let number = L10n.tr("Localizable", "setting.phone.number", fallback: "Phone number")
    }
    internal enum Push {
      /// App push notification
      internal static let notification = L10n.tr("Localizable", "setting.push.notification", fallback: "App push notification")
    }
  }
  internal enum Splash {
    /// EXPLORE NOW
    internal static let explore = L10n.tr("Localizable", "splash.explore", fallback: "EXPLORE NOW")
    /// Just a moment ...
    internal static let wait = L10n.tr("Localizable", "splash.wait", fallback: "Just a moment ...")
    /// Welcome to Noja Noja. Follow these steps to be our member.
    internal static let welcome = L10n.tr("Localizable", "splash.welcome", fallback: "Welcome to Noja Noja. Follow these steps to be our member.")
  }
  internal enum Telephone {
    internal enum Number {
      internal enum Service {
        /// 1588-1588
        internal static let center = L10n.tr("Localizable", "telephone.number.service.center", fallback: "1588-1588")
      }
    }
  }
  internal enum Tos {
    /// Compulsory
    internal static let compulsory = L10n.tr("Localizable", "tos.compulsory", fallback: "Compulsory")
    /// You may choose to agree to the terms individually. 
    /// You may use the service even if you don't agree to the optional terms and conditions
    internal static let description = L10n.tr("Localizable", "tos.description", fallback: "You may choose to agree to the terms individually. \nYou may use the service even if you don't agree to the optional terms and conditions")
    /// Optional
    internal static let `optional` = L10n.tr("Localizable", "tos.optional", fallback: "Optional")
    /// Terms of service
    internal static let title = L10n.tr("Localizable", "tos.title", fallback: "Terms of service")
    internal enum Agree {
      internal enum And {
        /// Agree and Continue
        internal static let `continue` = L10n.tr("Localizable", "tos.agree.and.continue", fallback: "Agree and Continue")
      }
    }
    internal enum Compulsory {
      internal enum Item {
        internal enum Title {
          /// I'm 14 years old older.
          internal static let _1 = L10n.tr("Localizable", "tos.compulsory.item.title.1", fallback: "I'm 14 years old older.")
          /// Terms and Conditions
          internal static let _2 = L10n.tr("Localizable", "tos.compulsory.item.title.2", fallback: "Terms and Conditions")
          /// Comprehensive Terms and Conditions
          internal static let _3 = L10n.tr("Localizable", "tos.compulsory.item.title.3", fallback: "Comprehensive Terms and Conditions")
          /// Collection and Use of Personal Information
          internal static let _4 = L10n.tr("Localizable", "tos.compulsory.item.title.4", fallback: "Collection and Use of Personal Information")
        }
      }
    }
    internal enum Optional {
      internal enum Item {
        internal enum Title {
          /// Consent to the collection and use of information
          internal static let _1 = L10n.tr("Localizable", "tos.optional.item.title.1", fallback: "Consent to the collection and use of information")
          /// Collection and Use of Profile Information
          internal static let _2 = L10n.tr("Localizable", "tos.optional.item.title.2", fallback: "Collection and Use of Profile Information")
        }
      }
    }
    internal enum Read {
      internal enum And {
        /// I have read and agreed to all terms and conditions
        internal static let agree = L10n.tr("Localizable", "tos.read.and.agree", fallback: "I have read and agreed to all terms and conditions")
      }
    }
  }
  internal enum Transaction {
    /// Detail Transaction
    internal static let detail = L10n.tr("Localizable", "transaction.detail", fallback: "Detail Transaction")
    /// Transaction History
    internal static let history = L10n.tr("Localizable", "transaction.history", fallback: "Transaction History")
    internal enum Detail {
      /// Status
      internal static let status = L10n.tr("Localizable", "transaction.detail.status", fallback: "Status")
      /// Time
      internal static let time = L10n.tr("Localizable", "transaction.detail.time", fallback: "Time")
    }
    internal enum History {
      /// %s point
      internal static func point(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "transaction.history.point", p1, fallback: "%s point")
      }
      internal enum Search {
        /// Search transaction
        internal static let hint = L10n.tr("Localizable", "transaction.history.search.hint", fallback: "Search transaction")
      }
    }
    internal enum Receive {
      /// Receive
      internal static let type = L10n.tr("Localizable", "transaction.receive.type", fallback: "Receive")
    }
    internal enum Spent {
      /// Spent
      internal static let type = L10n.tr("Localizable", "transaction.spent.type", fallback: "Spent")
    }
  }
  internal enum Transactions {
    internal enum History {
      internal enum Receive {
        /// Receive: %s
        internal static func reason(_ p1: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "transactions.history.receive.reason", p1, fallback: "Receive: %s")
        }
      }
      internal enum Spent {
        /// Spent: %s
        internal static func reason(_ p1: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "transactions.history.spent.reason", p1, fallback: "Spent: %s")
        }
      }
    }
  }
  internal enum Update {
    internal enum Profile {
      /// Set Avatar
      internal static let avatar = L10n.tr("Localizable", "update.profile.avatar", fallback: "Set Avatar")
      /// Day of Birth
      internal static let dob = L10n.tr("Localizable", "update.profile.dob", fallback: "Day of Birth")
      /// Gender
      internal static let gender = L10n.tr("Localizable", "update.profile.gender", fallback: "Gender")
      /// Name
      internal static let name = L10n.tr("Localizable", "update.profile.name", fallback: "Name")
      internal enum Avatar {
        internal enum Open {
          /// Open Camera
          internal static let camera = L10n.tr("Localizable", "update.profile.avatar.open.camera", fallback: "Open Camera")
        }
        internal enum Select {
          /// Select Photo
          internal static let photo = L10n.tr("Localizable", "update.profile.avatar.select.photo", fallback: "Select Photo")
        }
      }
      internal enum Gender {
        /// Female
        internal static let female = L10n.tr("Localizable", "update.profile.gender.female", fallback: "Female")
        /// Male
        internal static let male = L10n.tr("Localizable", "update.profile.gender.male", fallback: "Male")
        /// Other
        internal static let other = L10n.tr("Localizable", "update.profile.gender.other", fallback: "Other")
      }
      internal enum Name {
        /// Required
        internal static let `required` = L10n.tr("Localizable", "update.profile.name.required", fallback: "Required")
      }
    }
  }
  internal enum Video {
    /// Letâ€™s get points by watching
    internal static let title = L10n.tr("Localizable", "video.title", fallback: "Letâ€™s get points by watching")
    internal enum Detail {
      /// Comments
      internal static let comment = L10n.tr("Localizable", "video.detail.comment", fallback: "Comments")
      /// Reward
      internal static let reward = L10n.tr("Localizable", "video.detail.reward", fallback: "Reward")
      /// Views
      internal static let views = L10n.tr("Localizable", "video.detail.views", fallback: "Views")
      internal enum Comment {
        /// Newest
        internal static let newest = L10n.tr("Localizable", "video.detail.comment.newest", fallback: "Newest")
        /// Popular
        internal static let popular = L10n.tr("Localizable", "video.detail.comment.popular", fallback: "Popular")
      }
      internal enum Duration {
        /// %d days ago
        internal static func days(_ p1: Int) -> String {
          return L10n.tr("Localizable", "video.detail.duration.days", p1, fallback: "%d days ago")
        }
        /// %d hours ago
        internal static func hours(_ p1: Int) -> String {
          return L10n.tr("Localizable", "video.detail.duration.hours", p1, fallback: "%d hours ago")
        }
        /// %d minutes ago
        internal static func minutes(_ p1: Int) -> String {
          return L10n.tr("Localizable", "video.detail.duration.minutes", p1, fallback: "%d minutes ago")
        }
        /// %d months ago
        internal static func month(_ p1: Int) -> String {
          return L10n.tr("Localizable", "video.detail.duration.month", p1, fallback: "%d months ago")
        }
        /// %d years ago
        internal static func year(_ p1: Int) -> String {
          return L10n.tr("Localizable", "video.detail.duration.year", p1, fallback: "%d years ago")
        }
        internal enum Just {
          /// just now
          internal static let now = L10n.tr("Localizable", "video.detail.duration.just.now", fallback: "just now")
        }
      }
      internal enum Enter {
        /// Enter a comment
        internal static let comment = L10n.tr("Localizable", "video.detail.enter.comment", fallback: "Enter a comment")
      }
      internal enum Need {
        internal enum Youtube {
          /// You don't have a youtube account yet.
          internal static let account = L10n.tr("Localizable", "video.detail.need.youtube.account", fallback: "You don't have a youtube account yet.")
          internal enum Account {
            /// To comment on youtube you need an account. Click OK to see the tutorial on how to create youtube.
            internal static let description = L10n.tr("Localizable", "video.detail.need.youtube.account.description", fallback: "To comment on youtube you need an account. Click OK to see the tutorial on how to create youtube.")
          }
        }
      }
      internal enum Require {
        internal enum Google {
          /// You need login google and accept youtube scope to comment or like
          internal static let description = L10n.tr("Localizable", "video.detail.require.google.description", fallback: "You need login google and accept youtube scope to comment or like")
        }
      }
      internal enum Reward {
        /// %d point
        internal static func point(_ p1: Int) -> String {
          return L10n.tr("Localizable", "video.detail.reward.point", p1, fallback: "%d point")
        }
      }
      internal enum Short {
        /// %s · %s · %s
        internal static func description(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>, _ p3: UnsafePointer<CChar>) -> String {
          return L10n.tr("Localizable", "video.detail.short.description", p1, p2, p3, fallback: "%s · %s · %s")
        }
      }
    }
    internal enum List {
      /// Today features
      internal static let today = L10n.tr("Localizable", "video.list.today", fallback: "Today features")
      internal enum Watching {
        internal enum To {
          internal enum Get {
            /// Complete watching to reward Points
            internal static let point = L10n.tr("Localizable", "video.list.watching.to.get.point", fallback: "Complete watching to reward Points")
          }
        }
      }
    }
  }
  internal enum Wallet {
    internal enum Accumulated {
      /// Accumulated points for the day
      internal static let point = L10n.tr("Localizable", "wallet.accumulated.point", fallback: "Accumulated points for the day")
    }
    internal enum Attend {
      /// Attend now
      internal static let now = L10n.tr("Localizable", "wallet.attend.now", fallback: "Attend now")
    }
    internal enum Dashboard {
      /// Receive
      internal static let receive = L10n.tr("Localizable", "wallet.dashboard.receive", fallback: "Receive")
      /// Spent
      internal static let spent = L10n.tr("Localizable", "wallet.dashboard.spent", fallback: "Spent")
      /// Dashboard
      internal static let title = L10n.tr("Localizable", "wallet.dashboard.title", fallback: "Dashboard")
      internal enum Recent {
        /// Recent transactions
        internal static let transactions = L10n.tr("Localizable", "wallet.dashboard.recent.transactions", fallback: "Recent transactions")
      }
    }
    internal enum Exchange {
      /// Use now
      internal static let money = L10n.tr("Localizable", "wallet.exchange.money", fallback: "Use now")
    }
    internal enum Expect {
      internal enum Next {
        /// Expected ranking for next month
        internal static let tier = L10n.tr("Localizable", "wallet.expect.next.tier", fallback: "Expected ranking for next month")
      }
    }
    internal enum Gold {
      internal enum Member {
        /// Gold member ship
        internal static let ship = L10n.tr("Localizable", "wallet.gold.member.ship", fallback: "Gold member ship")
      }
    }
    internal enum History {
      /// Dashboard
      internal static let dashboard = L10n.tr("Localizable", "wallet.history.dashboard", fallback: "Dashboard")
    }
    internal enum My {
      /// My attendance
      internal static let attendance = L10n.tr("Localizable", "wallet.my.attendance", fallback: "My attendance")
      /// My point
      internal static let point = L10n.tr("Localizable", "wallet.my.point", fallback: "My point")
    }
    internal enum Number {
      /// Friend: %d
      internal static func friends(_ p1: Int) -> String {
        return L10n.tr("Localizable", "wallet.number.friends", p1, fallback: "Friend: %d")
      }
    }
    internal enum Point {
      /// Overall Point Ranking: %s
      internal static func ranking(_ p1: UnsafePointer<CChar>) -> String {
        return L10n.tr("Localizable", "wallet.point.ranking", p1, fallback: "Overall Point Ranking: %s")
      }
      internal enum Can {
        /// Points that can be exchanged
        internal static let exchange = L10n.tr("Localizable", "wallet.point.can.exchange", fallback: "Points that can be exchanged")
      }
    }
    internal enum Ranking {
      /// Bronze Membership
      internal static let bronze = L10n.tr("Localizable", "wallet.ranking.bronze", fallback: "Bronze Membership")
      /// Gold Membership
      internal static let gold = L10n.tr("Localizable", "wallet.ranking.gold", fallback: "Gold Membership")
      /// Premium Membership
      internal static let premium = L10n.tr("Localizable", "wallet.ranking.premium", fallback: "Premium Membership")
      /// Silver Membership
      internal static let silver = L10n.tr("Localizable", "wallet.ranking.silver", fallback: "Silver Membership")
    }
    internal enum View {
      /// View History
      internal static let history = L10n.tr("Localizable", "wallet.view.history", fallback: "View History")
    }
  }
  internal enum Welcome {
    /// Welcome to Noja Noja. Watch videos,play and earn.
    internal static let noljanolja = L10n.tr("Localizable", "welcome.noljanolja", fallback: "Welcome to Noja Noja. Watch videos,play and earn.")
  }
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
