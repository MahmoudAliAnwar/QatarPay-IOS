//
//  Helpers.swift
//  QPay
//
//  Created by Dev. Mohmd on 7/13/20.
//  Copyright © 2020 Dev. Mohmd. All rights reserved.
//

import Foundation
import UIKit

/// Put dummy data to app fields...
let isForDeveloping = false

/// Set BASE_URL to live
let isLiveApp: Bool = true

/// Show API Alamofire Error
let showAlamofireErrors: Bool = true

/// Show API User Exceptions
let showUserExceptions: Bool = true

// MARK:- Real Variables

let charityAmounts = ["50", "100", "300", "500"]

/// Library Fields Date Format
let libraryFieldsDateFormat = "dd/MM/yyyy"

/// Ammount TextFields Max Characters Length
let ammountFieldsMaxLength = 5

/// Recent Transactions Length
let recentTransactionsLength = 10

/// App Images Compression
let imagesCompressionQuality: CGFloat = 0.5

/// Delay actions after dismiss loading view by 0.5 seconds
let loadingViewDismissDelay: Double = 0.5

public typealias voidCompletion = (() -> Void)

public typealias UpdateClosure = (isSuccess: Bool, message: String)

public enum SignInUsers {
    case Me
    case Saneeb
    case Niji
    case Mahmoud
    case Test
    case Apple
    case None
}
 

typealias SignUpData = (firstName: String, lastName: String, email: String, password: String, confirmPassword: String)

let appBackgroundColor = UIColor(red: 72/255, green: 2/255, blue: 38/255, alpha: 1)

// MARK: - CHECK PASSWORD STRENGTH

public func checkPasswordStrength(password: String) -> Int {
    
    var strength = 0
    
    do {
        let capitalizePattern = "[A-Z]+"
        let specialCharsPattern = "[\\\\!\\@\\#\\$\\%^\\&\\*\\(\\)\\{\\}\\[\\]|\\/\\?\\<\\>\\-\\_\\=\\+]+"
        let numbersPattern = "[0-9]+"
        
        let capitalizeRegex = try NSRegularExpression(pattern: capitalizePattern, options: NSRegularExpression.Options(rawValue: 0))
        let specialCharsRegex = try NSRegularExpression(pattern: specialCharsPattern, options: NSRegularExpression.Options(rawValue: 0))
        let numbersRegex = try NSRegularExpression(pattern: numbersPattern, options: NSRegularExpression.Options(rawValue: 0))
        
        let range: NSRange = NSMakeRange(0, password.count)
        
        let capitalizeMatches = capitalizeRegex.matches(in: password, options: NSRegularExpression.MatchingOptions(), range: range)
        let specialCharsMatches = specialCharsRegex.matches(in: password, options: NSRegularExpression.MatchingOptions(), range: range)
        let numbersMatches = numbersRegex.matches(in: password, options: NSRegularExpression.MatchingOptions(), range: range)
        
        if capitalizeMatches.count > 0 {
            strength += 1
        }
        
        if specialCharsMatches.count > 0 {
            strength += 1
        }
        
        if numbersMatches.count > 0 {
            strength += 1
        }
        if password.count >= 6 {
            strength += 2
        }
        
    } catch let err {
        print("ERROR \(err.localizedDescription)")
    }
    return strength
}

// MARK: - VALID EMAIL FUNCTION

public func isValidEmail(_ emailAddress:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailAddress)
}

public func isValidURL(_ website:String) -> Bool {
    guard !website.contains("..") else { return false }
    
    let head     = "([(w|W)]{3}+\\.)?"
    let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
    let urlRegEx = head+"+(.)+"+tail
    
    let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    
    return urlTest.evaluate(with: website)
}

// MARK: - TRIM CODE FUNCTION

public func trimCode(_ code: String) -> [String] {
    
    var arr = [String]()
    
    code.enumerated().makeIterator().forEach { (arg0) in
        
        let (offset, element) = arg0
        if offset < 4 {
            if arr.isEmpty {
                arr.append(element.description)
            }else {
                arr[0] += element.description
            }
            
        }else if offset < 8 {
            if arr.count == 1 {
                arr.append(element.description)
            }else {
                arr[1] += element.description
            }
            
        }else if offset < 12 {
            if arr.count == 2 {
                arr.append(element.description)
            }else {
                arr[2] += element.description
            }
            
        }else if offset < 16 {
            if arr.count == 3 {
                arr.append(element.description)
            }else {
                arr[3] += element.description
            }
        }
    }
    return arr
}

struct Constant {
    
    static let KEY = "abbdfer5477djdnnndgdhhsfs555llkkfvv6ff36k"
    
    static var languages  = [
        "Arabic" ,
        "English" ,
        "Hindi" ,
        "Spanish" ,
        "French" ,
        "Urdu"
    ]
    
    
    static let genders = [
        "Any",
        "Male",
        "Female",
    ]
    
    static let industry = [
        "Any",
        "Air Conditioning / Refrigeration / HVAC",
        "Advertising / PR / Events",
        "Agriculture / Dairy / Poultry",
        "Airlines / Aviation",
        "Architecture / Interior Designing",
        "Automotive / Automobile / Auto Accessories",
        "Banking / Financial Services / Broking",
        "Chemicals / Petrochemicals / Polymers / Industrial Gases",
        "Construction / Civil Engineering",
        "Consumer Durables / Consumer Electronics",
        "FMCG / Foods / Beverage",
        "Courier / Logistics / Transportation / Warehousing",
        "Defence / Military / Government",
        "Education / Training / Teaching",
        "General Trading / Export / Import",
        "Fertilizers / Pesticides",
        "Fresher - No Industry Experience / Not Employed",
        "Gems &amp; Jewellery",
        "Hotels / Hospitality",
        "Industrial Products / Heavy Machinery",
        "Insurance",
        "Internet / E-Commerce / Dotcom",
        "IT - Hardware &amp; Networking",
        "IT - Software Services",
        "Media / Entertainment / Publishing",
        "Medical / Healthcare / Diagnostics / Medical Devices",
        "Metals / Steel / Iron / Aluminum / Foundry / Electroplating",
        "Mining / Forestry / Fishing",
        "NGO / Social Services / Community Services / Non-Profit",
        "Office Automation / Equipment / Stationery",
        "Oil &amp; Gas / Petroleum",
        "Paper",
        "Pharma / Biotech / Clinical Research",
        "Plastics / Rubber",
        "Power / Energy",
        "Printing / Packaging",
        "Real Estate",
        "Recruitment / Placement Firm",
        "Restaurants / Catering / Food Services",
        "Retail",
        "Security / Law Enforcement",
        "Shipping / Freight",
        "Telecom / ISP",
        "Fashion / Clothing / Accessories / Apparels",
        "Tyres",
        "Other" ]
    
    static let  profession = [
        "Any",
        "Accounts / Tax / CS / Audit",
        "Administration",
        "Advertising / Media Planning / PR",
        "Architecture / Interior Design",
        "Banking / Financial Services",
        "Corporate Planning / Consulting / Strategy",
        "Chefs / F&amp;B / Housekeeping / Front Desk",
        "Customer Service / Telecalling",
        "Doctor / Nurse / Paramedics / Hospital Technicians / Medical Research",
        "Engineering",
        "Equipment Operators/Inspectors",
        "Fresh Graduates / Management Trainee / Intern / No Experience",
        "Merchandising &amp; Planning",
        "Graphic Design / Web Design / Art / Visualiser",
        "Guards / Security Services",
        "HR / Human Relations",
        "Installation / Maintenance / Repair",
        "Insurance",
        "IT - Hardware",
        "IT - Software",
        "Journalism / Content / Editing",
        "Lawyers / Legal Advisors",
        "Marketing / Branding / Marketing Research / Digital Marketing",
        "Operations / Back Office Processing / Data Entry",
        "Production / Manufacturing",
        "Purchase / Logistics / Supply Chain / Procurement",
        "Quality / Testing / QA / QC",
        "R &amp; D",
        "Sales / Business Development",
        "Secretary / Front Office",
        "Site Engineering / Projects",
        "Teaching / Education / Translation",
        "Ticketing / Reservations",
        "Top Management",
        "TV Anchors / Reporters / Film Production / RJ / VJ",
        "Telecom",
        "Other"
    ]
    
    static let graduate = [
        "Any",
        "Intermediate School",
        "Secondary School",
        "Diploma",
        "Any Graduation",
        "Bachelor of Architecture",
        "Bachelor of Arts",
        "Bachelor of Business Administration",
        "Bachelor of Commerce",
        "Bachelor of Dental Surgery",
        "Bachelor of Education",
        "Bachelor of Hotel Management",
        "Bachelor of Laws (LLB)",
        "Bachelor of Pharmacy",
        "Bachelor of Science",
        "Bachelor of Technology/Engineering",
        "Bachelor of Veterinary Science",
        "Bachelors in Computer Application",
        "MBBS",
        "Other"
    ]
    
    static let residency = [
        "Any",
        "Any Arab Country",
        "Any GCC Country",
        "Any European Country",
        "Any Anglophone Country",
        "Any CIS Country",
        "Bahrain",
        "Egypt",
        "India",
        "Jordan",
        "Kuwait",
        "Lebanon",
        "Oman",
        "Palestine",
        "Qatar",
        "Saudi Arabia",
        "Tunisia",
        "United Arab Emirates",
        "Afghanistan",
        "Albania",
        "Algeria",
        "American Samoa",
        "Andorra",
        "Angola",
        "Argentina",
        "Armenia",
        "Australia",
        "Austria",
        "Azerbaijan",
        "Bahamas",
        "Bangladesh",
        "Barbados",
        "Belarus",
        "Belgium",
        "Belize",
        "Benin",
        "Bosnia and Herzegovina",
        "Botswana",
        "Brazil",
        "Brunei Darussalam",
        "Bulgaria",
        "Burkina Faso",
        "Burundi",
        "Cameroon",
        "Canada",
        "Cayman Islands",
        "Central African Republic",
        "Chad",
        "Chile",
        "China",
        "Colombia",
        "Comoros",
        "Congo",
        "Costa Rica",
        "Croatia (Hrvatska)",
        "Cuba",
        "Cyprus",
        "Czech Republic",
        "Denmark",
        "Djibouti",
        "Dominican Republic",
        "East Timor",
        "Ecuador",
        "El Salvador",
        "Eritrea",
        "Estonia",
        "Ethiopia",
        "Fiji",
        "Finland",
        "France",
        "Gabon",
        "Gambia",
        "Georgia",
        "Germany",
        "Ghana",
        "Greece",
        "Guatemala",
        "Guyana",
        "Haiti",
        "Honduras",
        "Hungary",
        "Iceland",
        "Indonesia",
        "Iran",
        "Iraq",
        "Ireland",
        "Italy",
        "Ivory Coast",
        "Jamaica",
        "Japan",
        "Kazakhstan",
        "Kenya",
        "Korea (North)",
        "Korea (South)",
        "Kyrgyzstan",
        "Laos",
        "Latvia",
        "Liberia",
        "Libya",
        "Lithuania",
        "Luxembourg",
        "Macedonia",
        "Madagascar",
        "Malawi",
        "Malaysia",
        "Maldives",
        "Mali",
        "Malta",
        "Mauritania",
        "Mauritius",
        "Mexico",
        "Moldova",
        "Monaco",
        "Mongolia",
        "Montenegro",
        "Morocco",
        "Mozambique",
        "Myanmar",
        "Namibia",
        "Nepal",
        "Netherlands",
        "Netherlands Antilles",
        "New Zealand",
        "Nicaragua",
        "Niger",
        "Nigeria",
        "Norway",
        "Pakistan",
        "Panama",
        "Paraguay",
        "Peru",
        "Philippines",
        "Poland",
        "Portugal",
        "Puerto Rico",
        "Romania",
        "Russian Federation",
        "Rwanda",
        "San Marino",
        "Senegal",
        "Serbia",
        "Seychelles",
        "Sierra Leone",
        "Singapore",
        "Slovak Republic",
        "Slovenia",
        "Somalia",
        "South Africa",
        "Spain",
        "Sri Lanka",
        "Sudan",
        "Swaziland",
        "Sweden",
        "Switzerland",
        "Syria",
        "Taiwan",
        "Tajikistan",
        "Tanzania",
        "Thailand",
        "Tonga",
        "Trinidad and Tobago",
        "Turkey",
        "Turkmenistan",
        "Uganda",
        "Ukraine",
        "United Kingdom (UK)",
        "United States Of America (USA)",
        "Uruguay",
        "Uzbekistan",
        "Vatican City State (Holy See)",
        "Venezuela",
        "Vietnam",
        "Western Sahara",
        "Yemen",
        "Yugoslavia",
        "Zambia",
        "Zimbabwe"
    ]
    
    static let nationality = [
        "Any",
        "Any Arabic National",
        "Any GCC National",
        "Any European National",
        "Any Anglophone National",
        "Any CIS National",
        "Bahraini",
        "Egyptian",
        "Indian",
        "Jordanian",
        "Kuwaiti",
        "Lebanese",
        "Omani",
        "Palestinian",
        "Qatari",
        "Saudi Arabian",
        "Tunisian",
        "Emirati (UAE)",
        "Afghan",
        "Albanian",
        "Algerian",
        "American (US)",
        "Andorran",
        "Angolian",
        "Argentine",
        "Armenian",
        "Australian",
        "Austrian",
        "Azerbaijani",
        "Bahamese",
        "Bahraini",
        "Bangladeshi",
        "Barbadian",
        "Belarusian",
        "Belgian",
        "Belizian",
        "Beninese",
        "Bosnian",
        "Brazilian",
        "British (UK)",
        "Bruneian",
        "Bulgarian",
        "Burkinabe",
        "Burman",
        "Burundian",
        "Cameroonian",
        "Canadian",
        "Cayman",
        "Central African National",
        "Chadian",
        "Chilean",
        "Chinese",
        "Colombian",
        "Comorian",
        "Congolese",
        "Costa Rican",
        "Croat",
        "Cuban",
        "Cypriot",
        "Czech",
        "Danish",
        "Djiboutian",
        "Dominican",
        "Dutch",
        "Dutch (Netherlands Antilles)",
        "Ecuadorian",
        "Egyptian",
        "Emirati (UAE)",
        "Eritrean",
        "Estonian",
        "Ethiopian",
        "Fijian",
        "Filipino",
        "Finnish",
        "French",
        "Gabonese",
        "Gambian",
        "Georgian",
        "German",
        "Ghanaian",
        "Greek",
        "Guatemalan",
        "Guyanese",
        "Haitian",
        "Honduran",
        "Hungarian",
        "Icelandic",
        "Indian",
        "Indonesian",
        "Iranian",
        "Iraqi",
        "Irish",
        "Italian",
        "Ivorian",
        "Jamaican",
        "Japanese",
        "Jordanian",
        "Kazakh",
        "Kenyan",
        "Korean (North)",
        "Korean (South)",
        "Kuwaiti",
        "Kyrgyz",
        "Laotian",
        "Latvian",
        "Lebanese",
        "Liberian",
        "Libyan",
        "Lithuanian",
        "Luxembourger",
        "Macedonian",
        "Malagasy",
        "Malawian",
        "Malaysian",
        "Maldivian",
        "Malian",
        "Maltese",
        "Mauritanian",
        "Mauritian",
        "Mexican",
        "Moldovan",
        "Monegasque",
        "Mongolian",
        "Montenegrin",
        "Moroccan",
        "Motswana",
        "Mozambican",
        "Namibian",
        "Nepali",
        "New Zealander",
        "Nicaraguan",
        "Nigerian (Nigeria)",
        "Nigerien (Niger)",
        "Norwegian",
        "Omani",
        "Pakistani",
        "Palestinian",
        "Panamanian",
        "Paraguayan",
        "Peruvian",
        "Polish",
        "Portuguese",
        "Puerto Rican",
        "Qatari",
        "Romanian",
        "Russian",
        "Rwandan",
        "Sahrawi",
        "Salvadoran",
        "Sammarinese",
        "Samoan",
        "Saudi Arabian",
        "Senegalese",
        "Serbian",
        "Seychellois",
        "Sierra Leonean",
        "Singaporean",
        "Slovak",
        "Slovenes",
        "Somali",
        "South African",
        "Spanish",
        "Sri Lankan",
        "Sudanese",
        "Swazi",
        "Swedish",
        "Swiss",
        "Syrian",
        "Taiwanese",
        "Tajik",
        "Tanzanian",
        "Thai",
        "Timorese",
        "Tongan",
        "Trini",
        "Tunisian",
        "Turkish",
        "Turkmen",
        "Ugandan",
        "Ukrainian",
        "Uruguayan",
        "Uzbek",
        "Vatican Citizen",
        "Venezuelan",
        "Vietnamese",
        "Yemeni",
        "Zambian",
        "Zimbabwean"
    ]
    
    static let expectedSalary = [
        "$1000",
        "$2000",
        "$3000",
        "$4000",
        "$5000",
        "$6000",
        "$7000",
        "$8000",
        "$9000",
        "$10000",
        "$15000",
        "$30000",
        "$50000",
        "Above $50001"
    ]
    
    static let emptypeType = [
        "Any",
        "Full-time",
        "Part-time",
        "Contract",
        "Other"
    ]
    
    static let jobTitles = [
        "Academic",
        "Accounting",
        "Admin",
        "Architecture",
        "Catering",
        "Chemical Engineering",
        "Civil Engineering",
        "Customer Service",
        "Design",
        "Driver",
        "Electronics Engineering",
        "Finance &amp; Consulting",
        "Healthcare",
        "Housemaid/Cleaner",
        "HR",
        "HSE",
        "Investment",
        "Journalism",
        "Legal",
        "Logistics",
        "Management",
        "Marketing",
        "Mechanical Engineering",
        "Nanny",
        "Network Admin",
        "Nursing",
        "Other",
        "Petroleum Engineering",
        "Physician",
        "Power Engineering",
        "Procurement",
        "R&amp;D",
        "Real Estate",
        "Retail Sales",
        "Sales",
        "Security",
        "Software Engineer",
        "Telesales",
        "Translation"
    ]
     
    static let experience = [
        "Any",
        "0–2 Years",
        "3–4 Years",
        "5–6 Years",
        "7+ Years"
    ]
    
    static let gender = [
        "Any",
        "Male",
        "Female"
    ]
}
