//
//  L102Language.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit


class LocalizeLanguage
{
    
    /// get current Apple language
    class func currentLanguage() -> String {
        if preferenceHelper.getLanguageCode().isEmpty
        {
            for iteratedLocale in Locale.preferredLanguages
            {
                let newLocal = Locale.init(identifier: iteratedLocale)
                for i in 0..<arrForLanguages.count
                {
                    if newLocal.languageCode ==  arrForLanguages[i].code
                    {
                        preferenceHelper.setLanguageCode(code: newLocal.languageCode!)
                        preferenceHelper.setLanguage(i)
                        return arrForLanguages[preferenceHelper.getLanguage()].code
                    }
                }

            }
        }
        return arrForLanguages[preferenceHelper.getLanguage()].code
        
    }
    
    class func currentAppleLanguageFull() -> String {
        
        let languageIndex = preferenceHelper.getLanguage()
        return arrForLanguages[languageIndex].language
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLanguageTo(lang: Int) {
        preferenceHelper.setLanguageCode(code: arrForLanguages[lang].1)
        preferenceHelper.setLanguage(lang)
    }

    /*class var isRTL: Bool {
        return LocalizeLanguage.currentLanguage() == "ar"
    }*/
}

