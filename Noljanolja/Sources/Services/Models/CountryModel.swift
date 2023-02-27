//
//  CountryModel.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import Foundation

// MARK: - Country

struct Country: Equatable {
    let nameCode: String
    let phoneCode: String
    let name: String

    init(_ nameCode: String, _ phoneCode: String, _ name: String) {
        self.nameCode = nameCode
        self.phoneCode = phoneCode
        self.name = name
    }
}

// MARK: Identifiable

extension Country: Identifiable {
    var id: String { nameCode }
}

extension Country {
    func getFlagEmoji() -> String {
        switch nameCode {
        case "ad": return "🇦🇩"
        case "ae": return "🇦🇪"
        case "af": return "🇦🇫"
        case "ag": return "🇦🇬"
        case "ai": return "🇦🇮"
        case "al": return "🇦🇱"
        case "am": return "🇦🇲"
        case "ao": return "🇦🇴"
        case "aq": return "🇦🇶"
        case "ar": return "🇦🇷"
        case "as": return "🇦🇸"
        case "at": return "🇦🇹"
        case "au": return "🇦🇺"
        case "aw": return "🇦🇼"
        case "ax": return "🇦🇽"
        case "az": return "🇦🇿"
        case "ba": return "🇧🇦"
        case "bb": return "🇧🇧"
        case "bd": return "🇧🇩"
        case "be": return "🇧🇪"
        case "bf": return "🇧🇫"
        case "bg": return "🇧🇬"
        case "bh": return "🇧🇭"
        case "bi": return "🇧🇮"
        case "bj": return "🇧🇯"
        case "bl": return "🇧🇱"
        case "bm": return "🇧🇲"
        case "bn": return "🇧🇳"
        case "bo": return "🇧🇴"
        case "bq": return "🇧🇶"
        case "br": return "🇧🇷"
        case "bs": return "🇧🇸"
        case "bt": return "🇧🇹"
        case "bv": return "🇧🇻"
        case "bw": return "🇧🇼"
        case "by": return "🇧🇾"
        case "bz": return "🇧🇿"
        case "ca": return "🇨🇦"
        case "cc": return "🇨🇨"
        case "cd": return "🇨🇩"
        case "cf": return "🇨🇫"
        case "cg": return "🇨🇬"
        case "ch": return "🇨🇭"
        case "ci": return "🇨🇮"
        case "ck": return "🇨🇰"
        case "cl": return "🇨🇱"
        case "cm": return "🇨🇲"
        case "cn": return "🇨🇳"
        case "co": return "🇨🇴"
        case "cr": return "🇨🇷"
        case "cu": return "🇨🇺"
        case "cv": return "🇨🇻"
        case "cw": return "🇨🇼"
        case "cx": return "🇨🇽"
        case "cy": return "🇨🇾"
        case "cz": return "🇨🇿"
        case "de": return "🇩🇪"
        case "dj": return "🇩🇯"
        case "dk": return "🇩🇰"
        case "dm": return "🇩🇲"
        case "do": return "🇩🇴"
        case "dz": return "🇩🇿"
        case "ec": return "🇪🇨"
        case "ee": return "🇪🇪"
        case "eg": return "🇪🇬"
        case "eh": return "🇪🇭"
        case "er": return "🇪🇷"
        case "es": return "🇪🇸"
        case "et": return "🇪🇹"
        case "fi": return "🇫🇮"
        case "fj": return "🇫🇯"
        case "fk": return "🇫🇰"
        case "fm": return "🇫🇲"
        case "fo": return "🇫🇴"
        case "fr": return "🇫🇷"
        case "ga": return "🇬🇦"
        case "gb": return "🇬🇧"
        case "gd": return "🇬🇩"
        case "ge": return "🇬🇪"
        case "gf": return "🇬🇫"
        case "gg": return "🇬🇬"
        case "gh": return "🇬🇭"
        case "gi": return "🇬🇮"
        case "gl": return "🇬🇱"
        case "gm": return "🇬🇲"
        case "gn": return "🇬🇳"
        case "gp": return "🇬🇵"
        case "gq": return "🇬🇶"
        case "gr": return "🇬🇷"
        case "gs": return "🇬🇸"
        case "gt": return "🇬🇹"
        case "gu": return "🇬🇺"
        case "gw": return "🇬🇼"
        case "gy": return "🇬🇾"
        case "hk": return "🇭🇰"
        case "hm": return "🇭🇲"
        case "hn": return "🇭🇳"
        case "hr": return "🇭🇷"
        case "ht": return "🇭🇹"
        case "hu": return "🇭🇺"
        case "id": return "🇮🇩"
        case "ie": return "🇮🇪"
        case "il": return "🇮🇱"
        case "im": return "🇮🇲"
        case "in": return "🇮🇳"
        case "io": return "🇮🇴"
        case "iq": return "🇮🇶"
        case "ir": return "🇮🇷"
        case "is": return "🇮🇸"
        case "it": return "🇮🇹"
        case "je": return "🇯🇪"
        case "jm": return "🇯🇲"
        case "jo": return "🇯🇴"
        case "jp": return "🇯🇵"
        case "ke": return "🇰🇪"
        case "kg": return "🇰🇬"
        case "kh": return "🇰🇭"
        case "ki": return "🇰🇮"
        case "km": return "🇰🇲"
        case "kn": return "🇰🇳"
        case "kp": return "🇰🇵"
        case "kr": return "🇰🇷"
        case "kw": return "🇰🇼"
        case "ky": return "🇰🇾"
        case "kz": return "🇰🇿"
        case "la": return "🇱🇦"
        case "lb": return "🇱🇧"
        case "lc": return "🇱🇨"
        case "li": return "🇱🇮"
        case "lk": return "🇱🇰"
        case "lr": return "🇱🇷"
        case "ls": return "🇱🇸"
        case "lt": return "🇱🇹"
        case "lu": return "🇱🇺"
        case "lv": return "🇱🇻"
        case "ly": return "🇱🇾"
        case "ma": return "🇲🇦"
        case "mc": return "🇲🇨"
        case "md": return "🇲🇩"
        case "me": return "🇲🇪"
        case "mf": return "🇲🇫"
        case "mg": return "🇲🇬"
        case "mh": return "🇲🇭"
        case "mk": return "🇲🇰"
        case "ml": return "🇲🇱"
        case "mm": return "🇲🇲"
        case "mn": return "🇲🇳"
        case "mo": return "🇲🇴"
        case "mp": return "🇲🇵"
        case "mq": return "🇲🇶"
        case "mr": return "🇲🇷"
        case "ms": return "🇲🇸"
        case "mt": return "🇲🇹"
        case "mu": return "🇲🇺"
        case "mv": return "🇲🇻"
        case "mw": return "🇲🇼"
        case "mx": return "🇲🇽"
        case "my": return "🇲🇾"
        case "mz": return "🇲🇿"
        case "na": return "🇳🇦"
        case "nc": return "🇳🇨"
        case "ne": return "🇳🇪"
        case "nf": return "🇳🇫"
        case "ng": return "🇳🇬"
        case "ni": return "🇳🇮"
        case "nl": return "🇳🇱"
        case "no": return "🇳🇴"
        case "np": return "🇳🇵"
        case "nr": return "🇳🇷"
        case "nu": return "🇳🇺"
        case "nz": return "🇳🇿"
        case "om": return "🇴🇲"
        case "pa": return "🇵🇦"
        case "pe": return "🇵🇪"
        case "pf": return "🇵🇫"
        case "pg": return "🇵🇬"
        case "ph": return "🇵🇭"
        case "pk": return "🇵🇰"
        case "pl": return "🇵🇱"
        case "pm": return "🇵🇲"
        case "pn": return "🇵🇳"
        case "pr": return "🇵🇷"
        case "ps": return "🇵🇸"
        case "pt": return "🇵🇹"
        case "pw": return "🇵🇼"
        case "py": return "🇵🇾"
        case "qa": return "🇶🇦"
        case "re": return "🇷🇪"
        case "ro": return "🇷🇴"
        case "rs": return "🇷🇸"
        case "ru": return "🇷🇺"
        case "rw": return "🇷🇼"
        case "sa": return "🇸🇦"
        case "sb": return "🇸🇧"
        case "sc": return "🇸🇨"
        case "sd": return "🇸🇩"
        case "se": return "🇸🇪"
        case "sg": return "🇸🇬"
        case "sh": return "🇸🇭"
        case "si": return "🇸🇮"
        case "sj": return "🇸🇯"
        case "sk": return "🇸🇰"
        case "sl": return "🇸🇱"
        case "sm": return "🇸🇲"
        case "sn": return "🇸🇳"
        case "so": return "🇸🇴"
        case "sr": return "🇸🇷"
        case "ss": return "🇸🇸"
        case "st": return "🇸🇹"
        case "sv": return "🇸🇻"
        case "sx": return "🇸🇽"
        case "sy": return "🇸🇾"
        case "sz": return "🇸🇿"
        case "tc": return "🇹🇨"
        case "td": return "🇹🇩"
        case "tf": return "🇹🇫"
        case "tg": return "🇹🇬"
        case "th": return "🇹🇭"
        case "tj": return "🇹🇯"
        case "tk": return "🇹🇰"
        case "tl": return "🇹🇱"
        case "tm": return "🇹🇲"
        case "tn": return "🇹🇳"
        case "to": return "🇹🇴"
        case "tr": return "🇹🇷"
        case "tt": return "🇹🇹"
        case "tv": return "🇹🇻"
        case "tw": return "🇹🇼"
        case "tz": return "🇹🇿"
        case "ua": return "🇺🇦"
        case "ug": return "🇺🇬"
        case "um": return "🇺🇲"
        case "us": return "🇺🇸"
        case "uy": return "🇺🇾"
        case "uz": return "🇺🇿"
        case "va": return "🇻🇦"
        case "vc": return "🇻🇨"
        case "ve": return "🇻🇪"
        case "vg": return "🇻🇬"
        case "vi": return "🇻🇮"
        case "vn": return "🇻🇳"
        case "vu": return "🇻🇺"
        case "wf": return "🇼🇫"
        case "ws": return "🇼🇸"
        case "xk": return "🇽🇰"
        case "ye": return "🇾🇪"
        case "yt": return "🇾🇹"
        case "za": return "🇿🇦"
        case "zm": return "🇿🇲"
        case "zw": return "🇿🇼"
        default: return " "
        }
    }
}

extension Country {
    static let `default` = Country("vn", "84", "Vietnam")

    static let countries = [
        Country("ad", "376", "Andorra"),
        Country("ae", "971", "United Arab Emirates (UAE)"),
        Country("af", "93", "Afghanistan"),
        Country("ag", "1", "Antigua and Barbuda"),
        Country("ai", "1", "Anguilla"),
        Country("al", "355", "Albania"),
        Country("am", "374", "Armenia"),
        Country("ao", "244", "Angola"),
        Country("aq", "672", "Antarctica"),
        Country("ar", "54", "Argentina"),
        Country("as", "1", "American Samoa"),
        Country("at", "43", "Austria"),
        Country("au", "61", "Australia"),
        Country("aw", "297", "Aruba"),
        Country("ax", "358", "Åland Islands"),
        Country("az", "994", "Azerbaijan"),
        Country("ba", "387", "Bosnia And Herzegovina"),
        Country("bb", "1", "Barbados"),
        Country("bd", "880", "Bangladesh"),
        Country("be", "32", "Belgium"),
        Country("bf", "226", "Burkina Faso"),
        Country("bg", "359", "Bulgaria"),
        Country("bh", "973", "Bahrain"),
        Country("bi", "257", "Burundi"),
        Country("bj", "229", "Benin"),
        Country("bl", "590", "Saint Barthélemy"),
        Country("bm", "1", "Bermuda"),
        Country("bn", "673", "Brunei Darussalam"),
        Country("bo", "591", "Bolivia, Plurinational State Of"),
        Country("br", "55", "Brazil"),
        Country("bs", "1", "Bahamas"),
        Country("bt", "975", "Bhutan"),
        Country("bw", "267", "Botswana"),
        Country("by", "375", "Belarus"),
        Country("bz", "501", "Belize"),
        Country("ca", "1", "Canada"),
        Country("cc", "61", "Cocos (keeling) Islands"),
        Country("cd", "243", "Congo, The Democratic Republic Of The"),
        Country("cf", "236", "Central African Republic"),
        Country("cg", "242", "Congo"),
        Country("ch", "41", "Switzerland"),
        Country("ci", "225", "Côte D'ivoire"),
        Country("ck", "682", "Cook Islands"),
        Country("cl", "56", "Chile"),
        Country("cm", "237", "Cameroon"),
        Country("cn", "86", "China"),
        Country("co", "57", "Colombia"),
        Country("cr", "506", "Costa Rica"),
        Country("cu", "53", "Cuba"),
        Country("cv", "238", "Cape Verde"),
        Country("cw", "599", "Curaçao"),
        Country("cx", "61", "Christmas Island"),
        Country("cy", "357", "Cyprus"),
        Country("cz", "420", "Czech Republic"),
        Country("de", "49", "Germany"),
        Country("dj", "253", "Djibouti"),
        Country("dk", "45", "Denmark"),
        Country("dm", "1", "Dominica"),
        Country("do", "1", "Dominican Republic"),
        Country("dz", "213", "Algeria"),
        Country("ec", "593", "Ecuador"),
        Country("ee", "372", "Estonia"),
        Country("eg", "20", "Egypt"),
        Country("er", "291", "Eritrea"),
        Country("es", "34", "Spain"),
        Country("et", "251", "Ethiopia"),
        Country("fi", "358", "Finland"),
        Country("fj", "679", "Fiji"),
        Country("fk", "500", "Falkland Islands (malvinas)"),
        Country("fm", "691", "Micronesia, Federated States Of"),
        Country("fo", "298", "Faroe Islands"),
        Country("fr", "33", "France"),
        Country("ga", "241", "Gabon"),
        Country("gb", "44", "United Kingdom"),
        Country("gd", "1", "Grenada"),
        Country("ge", "995", "Georgia"),
        Country("gf", "594", "French Guyana"),
        Country("gh", "233", "Ghana"),
        Country("gi", "350", "Gibraltar"),
        Country("gl", "299", "Greenland"),
        Country("gm", "220", "Gambia"),
        Country("gn", "224", "Guinea"),
        Country("gp", "450", "Guadeloupe"),
        Country("gq", "240", "Equatorial Guinea"),
        Country("gr", "30", "Greece"),
        Country("gt", "502", "Guatemala"),
        Country("gu", "1", "Guam"),
        Country("gw", "245", "Guinea-bissau"),
        Country("gy", "592", "Guyana"),
        Country("hk", "852", "Hong Kong"),
        Country("hn", "504", "Honduras"),
        Country("hr", "385", "Croatia"),
        Country("ht", "509", "Haiti"),
        Country("hu", "36", "Hungary"),
        Country("id", "62", "Indonesia"),
        Country("ie", "353", "Ireland"),
        Country("il", "972", "Israel"),
        Country("im", "44", "Isle Of Man"),
        Country("is", "354", "Iceland"),
        Country("in", "91", "India"),
        Country("io", "246", "British Indian Ocean Territory"),
        Country("iq", "964", "Iraq"),
        Country("ir", "98", "Iran, Islamic Republic Of"),
        Country("it", "39", "Italy"),
        Country("je", "44", "Jersey "),
        Country("jm", "1", "Jamaica"),
        Country("jo", "962", "Jordan"),
        Country("jp", "81", "Japan"),
        Country("ke", "254", "Kenya"),
        Country("kg", "996", "Kyrgyzstan"),
        Country("kh", "855", "Cambodia"),
        Country("ki", "686", "Kiribati"),
        Country("km", "269", "Comoros"),
        Country("kn", "1", "Saint Kitts and Nevis"),
        Country("kp", "850", "North Korea"),
        Country("kr", "82", "South Korea"),
        Country("kw", "965", "Kuwait"),
        Country("ky", "1", "Cayman Islands"),
        Country("kz", "7", "Kazakhstan"),
        Country("la", "856", "Lao People's Democratic Republic"),
        Country("lb", "961", "Lebanon"),
        Country("lc", "1", "Saint Lucia"),
        Country("li", "423", "Liechtenstein"),
        Country("lk", "94", "Sri Lanka"),
        Country("lr", "231", "Liberia"),
        Country("ls", "266", "Lesotho"),
        Country("lt", "370", "Lithuania"),
        Country("lu", "352", "Luxembourg"),
        Country("lv", "371", "Latvia"),
        Country("ly", "218", "Libya"),
        Country("ma", "212", "Morocco"),
        Country("mc", "377", "Monaco"),
        Country("md", "373", "Moldova, Republic Of"),
        Country("me", "382", "Montenegro"),
        Country("mf", "590", "Saint Martin"),
        Country("mg", "261", "Madagascar"),
        Country("mh", "692", "Marshall Islands"),
        Country("mk", "389", "Macedonia (FYROM)"),
        Country("ml", "223", "Mali"),
        Country("mm", "95", "Myanmar"),
        Country("mn", "976", "Mongolia"),
        Country("mo", "853", "Macau"),
        Country("mp", "1", "Northern Mariana Islands"),
        Country("mq", "596", "Martinique"),
        Country("mr", "222", "Mauritania"),
        Country("ms", "1", "Montserrat"),
        Country("mt", "356", "Malta"),
        Country("mu", "230", "Mauritius"),
        Country("mv", "960", "Maldives"),
        Country("mw", "265", "Malawi"),
        Country("mx", "52", "Mexico"),
        Country("my", "60", "Malaysia"),
        Country("mz", "258", "Mozambique"),
        Country("na", "264", "Namibia"),
        Country("nc", "687", "New Caledonia"),
        Country("ne", "227", "Niger"),
        Country("nf", "672", "Norfolk Islands"),
        Country("ng", "234", "Nigeria"),
        Country("ni", "505", "Nicaragua"),
        Country("nl", "31", "Netherlands"),
        Country("no", "47", "Norway"),
        Country("np", "977", "Nepal"),
        Country("nr", "674", "Nauru"),
        Country("nu", "683", "Niue"),
        Country("nz", "64", "New Zealand"),
        Country("om", "968", "Oman"),
        Country("pa", "507", "Panama"),
        Country("pe", "51", "Peru"),
        Country("pf", "689", "French Polynesia"),
        Country("pg", "675", "Papua New Guinea"),
        Country("ph", "63", "Philippines"),
        Country("pk", "92", "Pakistan"),
        Country("pl", "48", "Poland"),
        Country("pm", "508", "Saint Pierre And Miquelon"),
        Country("pn", "870", "Pitcairn Islands"),
        Country("pr", "1", "Puerto Rico"),
        Country("ps", "970", "Palestine"),
        Country("pt", "351", "Portugal"),
        Country("pw", "680", "Palau"),
        Country("py", "595", "Paraguay"),
        Country("qa", "974", "Qatar"),
        Country("re", "262", "Réunion"),
        Country("ro", "40", "Romania"),
        Country("rs", "381", "Serbia"),
        Country("ru", "7", "Russian Federation"),
        Country("rw", "250", "Rwanda"),
        Country("sa", "966", "Saudi Arabia"),
        Country("sb", "677", "Solomon Islands"),
        Country("sc", "248", "Seychelles"),
        Country("sd", "249", "Sudan"),
        Country("se", "46", "Sweden"),
        Country("sg", "65", "Singapore"),
        Country("sh", "290", "Saint Helena, Ascension And Tristan Da Cunha"),
        Country("si", "386", "Slovenia"),
        Country("sk", "421", "Slovakia"),
        Country("sl", "232", "Sierra Leone"),
        Country("sm", "378", "San Marino"),
        Country("sn", "221", "Senegal"),
        Country("so", "252", "Somalia"),
        Country("sr", "597", "Suriname"),
        Country("ss", "211", "South Sudan"),
        Country("st", "239", "Sao Tome And Principe"),
        Country("sv", "503", "El Salvador"),
        Country("sx", "1", "Sint Maarten"),
        Country("sy", "963", "Syrian Arab Republic"),
        Country("sz", "268", "Swaziland"),
        Country("tc", "1", "Turks and Caicos Islands"),
        Country("td", "235", "Chad"),
        Country("tg", "228", "Togo"),
        Country("th", "66", "Thailand"),
        Country("tj", "992", "Tajikistan"),
        Country("tk", "690", "Tokelau"),
        Country("tl", "670", "Timor-leste"),
        Country("tm", "993", "Turkmenistan"),
        Country("tn", "216", "Tunisia"),
        Country("to", "676", "Tonga"),
        Country("tr", "90", "Turkey"),
        Country("tt", "1", "Trinidad &amp; Tobago"),
        Country("tv", "688", "Tuvalu"),
        Country("tw", "886", "Taiwan"),
        Country("tz", "255", "Tanzania, United Republic Of"),
        Country("ua", "380", "Ukraine"),
        Country("ug", "256", "Uganda"),
        Country("us", "1", "United States"),
        Country("uy", "598", "Uruguay"),
        Country("uz", "998", "Uzbekistan"),
        Country("va", "379", "Holy See (vatican City State)"),
        Country("vc", "1", "Saint Vincent & The Grenadines"),
        Country("ve", "58", "Venezuela, Bolivarian Republic Of"),
        Country("vg", "1", "British Virgin Islands"),
        Country("vi", "1", "US Virgin Islands"),
        Country("vn", "84", "Vietnam"),
        Country("vu", "678", "Vanuatu"),
        Country("wf", "681", "Wallis And Futuna"),
        Country("ws", "685", "Samoa"),
        Country("xk", "383", "Kosovo"),
        Country("ye", "967", "Yemen"),
        Country("yt", "262", "Mayotte"),
        Country("za", "27", "South Africa"),
        Country("zm", "260", "Zambia"),
        Country("zw", "263", "Zimbabwe")
    ]
}
