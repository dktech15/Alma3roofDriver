//
//  AlamofireHelper.swift
//  Store
//
//  Created by Elluminati on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//


import Foundation
class Parser: NSObject {
    
    //MARK:- parseBasicSettingDetails
    class func parseAppSettingDetail(response:[String:Any],data:Data?)-> Bool {
        if self.isSuccess(response: response, data: data) {
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            
            let settingResponse:AppSettingResponse = try jsonDecoder.decode(AppSettingResponse.self, from: data!)
            ProviderSingleton.shared.settingResponse = settingResponse
            
            if let setting = settingResponse.settingDetail {
                preferenceHelper.setStripeKey(setting.stripePublishableKey!);
                preferenceHelper.setGoogleKey(setting.iosProviderAppGoogleKey!)
                preferenceHelper.setGooglePlacesAutocompleteKey(setting.ios_places_autocomplete_key)
                preferenceHelper.setIsPhoneNumberVerification(setting.providerSms)
                preferenceHelper.setIsEmailVerification(setting.providerEmailVerification!)
                preferenceHelper.setIsTwillioEnable(setting.isTwilioCallMasking)
                preferenceHelper.setContactEmail(setting.contactUsEmail!)
                preferenceHelper.setContactNumber(setting.adminPhone!)
                preferenceHelper.setIsGenderShow(settingResponse.isGenderShow)
                
                preferenceHelper.setIsPathdraw(setting.providerPath!);
                preferenceHelper.setIsShowEta(setting.isShowEstimationInProviderApp!);
                preferenceHelper.setIsRequiredForceUpdate(setting.iosProviderAppForceUpdate!)
                preferenceHelper.setPreSchedualTripTime(setting.scheduledRequestPreStartMinute!)
                preferenceHelper.setLatestVersion(setting.iosProviderAppVersionCode!)
                preferenceHelper.setIsProviderInitiateTrip(setting.isProviderInitiateTrip)
                
                preferenceHelper.setPrivacyPolicy(setting.privacyPolicyUrl)
                preferenceHelper.setTermsAndCondition(setting.termsCondition)
                
                preferenceHelper.setMinMobileLength(setting.minimum_phone_number_length)
                preferenceHelper.setMaxMobileLength(setting.maximum_phone_number_length)
                
                preferenceHelper.setIsUseSocialLogin(setting.is_provider_social_login)
                
                preferenceHelper.setGoingHomeOn(setting.isDriverGoHome)
                preferenceHelper.setGoingHomeAddressOn(setting.isDriverGoHomeChangeAddress)
                preferenceHelper.setPaypalClientId(setting.paypal_client_id)
                preferenceHelper.setIsLoginWithOTP(setting.is_provider_login_using_otp)
                preferenceHelper.setIsShowUserDetailInTrip(setting.is_show_user_details_in_provider_app)
                preferenceHelper.setAllowBiomatricVerification(setting.is_allow_biomatric_verification)
                preferenceHelper.setFireBaseKey(setting.android_provider_app_gcm_key)
                
                if  (setting.imageBaseUrl.isEmpty()) {
                    preferenceHelper.setImageBaseUrl(WebService.BASE_URL)
                    //WebService.IMAGE_BASE_URL = WebService.BASE_URL
                }else {
                    preferenceHelper.setImageBaseUrl(setting.imageBaseUrl)
                    //WebService.IMAGE_BASE_URL = setting.imageBaseUrl
                }
                preferenceHelper.setMinMobileLength(setting.minimum_phone_number_length)
                preferenceHelper.setMaxMobileLength(setting.maximum_phone_number_length)
                
                preferenceHelper.setIsUseSocialLogin(setting.is_provider_social_login)
                
                preferenceHelper.setGoingHomeOn(setting.isDriverGoHome)
                preferenceHelper.setGoingHomeAddressOn(setting.isDriverGoHomeChangeAddress)
                preferenceHelper.setPaypalClientId(setting.paypal_client_id)
                preferenceHelper.setIsLoginWithOTP(setting.is_provider_login_using_otp)
                preferenceHelper.setIsShowUserDetailInTrip(setting.is_show_user_details_in_provider_app)
                preferenceHelper.setFireBaseKey(setting.android_provider_app_gcm_key)
                
            }
            
            if let providerDetail = settingResponse.providerDetail{
                preferenceHelper.setCountryCode(providerDetail.countryPhoneCode)

                preferenceHelper.setWalletCurrencyCode(providerDetail.walletCurrencyCode)
                preferenceHelper.setDriverRedeemPointValue(providerDetail.driverRedeemPointValue)
                preferenceHelper.setIsSendMoney(providerDetail.isSendMoney)
            }
            
//            preferenceHelper.setPrivacyPolicy(WebService.BASE_URL + WebService.PRIVACY_POLICY_URL)
//            preferenceHelper.setTermsAndCondition(WebService.BASE_URL + WebService.TERMS_CONDITION_URL)
            

           
           
            
            
            if settingResponse.providerDetail != nil {
                ProviderSingleton.shared.provider = settingResponse.providerDetail!
            }
            
            if settingResponse.firstTrip != nil {
                //let trip = settingResponse.firstTrip!
                //ProviderSingleton.shared.tripUser =  trip.user
                //ProviderSingleton.shared.tripId = trip.tripId
                ProviderSingleton.shared.tripId = settingResponse.firstTrip!
                //ProviderSingleton.shared.isTripEnd = trip.isTripEnd
                //ProviderSingleton.shared.isProviderStatus = trip.isProviderStatus
                //ProviderSingleton.shared.timeLeftToRespondTrip = trip.timeLeftToRespondsTrip
            }
            
            if settingResponse.nearTripDetail != nil {
                AppDelegate.SharedApplication().nearTripDetail = settingResponse.nearTripDetail
                ProviderSingleton.shared.nearTripUser = settingResponse.nearTripDetail!.user
                ProviderSingleton.shared.nearTripId = settingResponse.nearTripDetail!.tripId
                ProviderSingleton.shared.nearIsTripEnd = settingResponse.nearTripDetail!.isTripEnd
                ProviderSingleton.shared.nearIsProviderStatus = settingResponse.nearTripDetail!.isProviderStatus
                ProviderSingleton.shared.nearTimeLeftToRespondTrip = settingResponse.nearTripDetail!.timeLeftToRespondsTrip
            }
            else {
                AppDelegate.SharedApplication().nearTripDetail = nil
            }
            
            return true
        }catch {
            print("parseAppSettingDetail error")
            return false
        }
    }
    
    //MARK:- Invoice For Earning Detail
    class func parseEarning(_ response: [String:Any], data:Data?, arrayListForEarning:NSMutableArray, arrayListForAnalytic:NSMutableArray, arrayListForOrders:NSMutableArray, isWeeklyEarning: Bool = false, completetion: @escaping (_ result: Bool) -> Void) {
        
        arrayListForEarning.removeAllObjects()
        arrayListForAnalytic.removeAllObjects()
        arrayListForOrders.removeAllObjects()
        if (isSuccess(response: response, data:data,withSuccessToast: false, andErrorToast: true)) {
            let jsonDecoder = JSONDecoder()
            do {
                let dailyEarningResponse:EarningResponse = try jsonDecoder.decode(EarningResponse.self, from: data!)
                
                let orderTotalItem:EarningProviderDailyEarning = (dailyEarningResponse.providerDailyEarning ?? dailyEarningResponse.providerWeeklyEarning)!
                
                let tag1:String = "TXT_TRIP_EARNING".localized
                let tag2:String = "TXT_PROVIDER_TRANSACTIONS".localized
                let tag3:String = "TXT_PAYMENT".localized
                
                var earningDataArrayList:Array<Earning> = Array();
                
                earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_SERVICE_PRICE".localized, price: (orderTotalItem.serviceTotal).toString()))
                
                earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_SURGE_PRICE".localized, price: "+" + (orderTotalItem.totalServiceSurgeFees).toString()))
                
                earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_TAX".localized, price: (orderTotalItem.totalProviderTaxFees).toString()))
                
                earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_MISCELLANEOUS_PRICE".localized, price:(orderTotalItem.totalProviderMiscellaneousFees).toString()))
                
                earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_TOLL_AMOUNT".localized, price:(orderTotalItem.totalTollAmount).toString()))
                
                earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_TIP_AMOUNT".localized, price:(orderTotalItem.totalTipAmount).toString()))
                
                arrayListForEarning.add(earningDataArrayList);
                
                var earningDataArrayList2:Array<Earning> = Array();
                
                earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_PROVIDER_HAVE_CASH".localized, price:  (orderTotalItem.totalProviderHaveCash).toString()))
                
                earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_DEDUCT_WALLET_AMOUNT".localized, price:(orderTotalItem.totalAddedWalletAmount).toString()))
                
                earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_ADDED_WALLET_AMOUNT".localized, price: (orderTotalItem.totalDeductWalletAmount).toString()))
                
                arrayListForEarning.add(earningDataArrayList2);
                
                var earningDataArrayList3:Array<Earning> = Array();
                
                
                earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_TOTAL_EARNING".localized, price: (orderTotalItem.totalProviderServiceFees).toString()))
                earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_PAID_IN_WALLET".localized, price: (orderTotalItem.totalPaidInWalletPayment).toString()))
                
                earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_AMOUNT_TRANSFERRED".localized, price: (orderTotalItem.totalTransferredAmount).toString()))
                
                earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_PAY_TO_PROVIDER".localized, price: (orderTotalItem.totalPayToProvider).toString()))
                
                arrayListForEarning.add(earningDataArrayList3);
                
                let analyticDaily:EarningProviderDailyAnalytic = (dailyEarningResponse.providerDailyAnalytic ?? dailyEarningResponse.providerWeeklyAnalytic )!
                
                arrayListForAnalytic.add(Analytic.init(title: "TXT_TIME_ONLINE".localized, value: Utility.secondsToHoursMinutes(seconds: Int64(analyticDaily.totalOnlineTime))) as Any)
                
                arrayListForAnalytic.add(Analytic.init(title: "TXT_RECEIVED_REQUEST".localized, value: String(analyticDaily.received)) as Any)
                
                arrayListForAnalytic.add(Analytic.init(title: "TXT_ACCEPTED_ORDER".localized, value: String(analyticDaily.accepted)) as Any)
                arrayListForAnalytic.add(Analytic.init(title: "TXT_ACCEPTED_RATIO".localized, value: String(format:"%.2f", analyticDaily.acceptionRatio) + "%") as Any)
                
                arrayListForAnalytic.add(Analytic.init(title: "TXT_COMPLETED_ORDER".localized, value: String(analyticDaily.completed)) as Any)
                arrayListForAnalytic.add(Analytic.init(title: "TXT_COMPLETED_RATIO".localized, value: String(format:"%.2f", analyticDaily.completedRatio) + "%") as Any)
                
                arrayListForAnalytic.add(Analytic.init(title: "TXT_REJECTED_ORDER".localized, value: String(analyticDaily.rejected)) as Any)
                arrayListForAnalytic.add(Analytic.init(title: "TXT_REJECTED_RATIO".localized, value: String(format:"%.2f", analyticDaily.rejectionRatio) + "%") as Any)
                
                arrayListForAnalytic.add(Analytic.init(title: "TXT_CANCELLED_ORDER".localized, value: String(analyticDaily.cancelled)) as Any)
                arrayListForAnalytic.add(Analytic.init(title: "TXT_CANCELLED_RATIO".localized, value: String(format:"%.2f", analyticDaily.cancellationRatio) + "%") as Any)
                
                if isWeeklyEarning {
                    let date:EarningDate = dailyEarningResponse.date!
                    let earning:EarningTripDayTotal = dailyEarningResponse.tripDayTotal!
                    arrayListForOrders.add(Analytic.init(title: date.date1 , value: earning.date1.toString()) as Any)
                    arrayListForOrders.add(Analytic.init(title: date.date2 , value: earning.date2.toString()) as Any)
                    arrayListForOrders.add(Analytic.init(title: date.date3 , value: earning.date3.toString()) as Any)
                    arrayListForOrders.add(Analytic.init(title: date.date4 , value: earning.date4.toString()) as Any)
                    arrayListForOrders.add(Analytic.init(title: date.date5 , value: earning.date5.toString()) as Any)
                    arrayListForOrders.add(Analytic.init(title: date.date6 , value: earning.date6.toString()) as Any)
                    arrayListForOrders.add(Analytic.init(title: date.date7 , value: earning.date7.toString()) as Any)
                }else {
                    for orderPayment in dailyEarningResponse.trips {
                        arrayListForOrders.add(orderPayment)
                    }
                }
            }catch {
                print("wrong response")
            }
            completetion(true)
        }else {
            completetion(false)
        }
    }
    
    class func parseProviderData(response:[String:Any],data:Data?)-> Bool {
        if self.isSuccess(response: response, data: data) {
            
            let jsonDecoder = JSONDecoder()
            do {
                
                if let data = data {
                    do {
                        let settingResponse = try jsonDecoder.decode(AppSettingResponse.self, from: data)
                        // Continue with your logic
                    } catch {
                        print("Decoding error: \(error)")
                    }
                } else {
                    print("Data is nil")
                }

                
                let settingResponse:AppSettingResponse = try jsonDecoder.decode(AppSettingResponse.self, from: data!)
                if settingResponse.providerDetail != nil {
                    ProviderSingleton.shared.provider = settingResponse.providerDetail!
                    preferenceHelper.setUserId(ProviderSingleton.shared.provider.providerId)
                    preferenceHelper.setSessionToken(ProviderSingleton.shared.provider.token)
                }
                if settingResponse.firstTrip != nil {
                    //let trip = settingResponse.firstTrip!
                    //ProviderSingleton.shared.tripUser = trip.user
                    //ProviderSingleton.shared.tripId = trip.tripId
                    ProviderSingleton.shared.tripId = settingResponse.firstTrip!
                    //ProviderSingleton.shared.isTripEnd = trip.isTripEnd
                    //ProviderSingleton.shared.isProviderStatus = trip.isProviderStatus
                    //ProviderSingleton.shared.timeLeftToRespondTrip = trip.timeLeftToRespondsTrip
                }
                if settingResponse.nearTripDetail != nil {
                    ProviderSingleton.shared.nearTripUser = settingResponse.nearTripDetail!.user
                    ProviderSingleton.shared.nearTripId = settingResponse.nearTripDetail!.tripId
                    ProviderSingleton.shared.nearIsTripEnd = settingResponse.nearTripDetail!.isTripEnd
                    ProviderSingleton.shared.nearIsProviderStatus = settingResponse.nearTripDetail!.isProviderStatus
                    ProviderSingleton.shared.nearTimeLeftToRespondTrip = settingResponse.nearTripDetail!.timeLeftToRespondsTrip
                }

                return true
            }catch {
                return false
            }
        }else {
            return false
        }
    }
    
    class func parseProviderDetail(response:[String:Any], data: Data?)-> Bool {
        if self.isSuccess(response: response, data: data) {
            let jsonDecoder = JSONDecoder()
            do {
                let providerDetailResponse:ProviderDetailResponse = try jsonDecoder.decode(ProviderDetailResponse.self, from: data!)
                let provider =  providerDetailResponse.provider
                ProviderSingleton.shared.provider.fillProviderWith(provider: provider)
                preferenceHelper.setUserId(provider.id)
                preferenceHelper.setSessionToken(provider.token)
            
                return true
            }catch {
                return false
            }
        }else {
            return false
        }
    }
    
    class func parseTrips(response:[String:Any],data:Data?)-> Bool {
        if self.isSuccess(response: response, data: data,withSuccessToast: false,andErrorToast: false) {
            let jsonDecoder = JSONDecoder()
            do {
                let providerTripsResponse:TripsRespons = try jsonDecoder.decode(TripsRespons.self, from: data!)
                if providerTripsResponse.timeLeftToRespondsTrip > 1 {
                    ProviderSingleton.shared.tripUser =  providerTripsResponse.user
                    ProviderSingleton.shared.tripId = providerTripsResponse.tripId
                    ProviderSingleton.shared.timeLeftToRespondTrip = providerTripsResponse.timeLeftToRespondsTrip
                    return true
                }
                return false
            }catch {
                return false
            }
        }else {
            return false
        }
    }
    
    class func parseWalletHistory(_ response: [String:Any],data:Data? ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response,data: data, withSuccessToast: false, andErrorToast: true)) {
            
            let jsonDecoder = JSONDecoder()
            do {
                let walletListResponse:WalletHistoryResponse = try jsonDecoder.decode(WalletHistoryResponse.self, from: data!)
                let walletHistoryList:[WalletHistoryItem] = walletListResponse.walletHistory
                if walletHistoryList.count > 0 {
                    for walletHistoryItem in walletHistoryList {
                        toArray.add(walletHistoryItem)
                    }
                    completion(true)
                }else {
                    completion(false)
                }
            }catch {
                
            }
        }
    }
    class func parseRedeemHistory(_ response: [String:Any],data:Data? ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response,data: data, withSuccessToast: false, andErrorToast: true)) {
            
            let jsonDecoder = JSONDecoder()
            do {
                let redeemListResponse:RedeemHistoryResponse = try jsonDecoder.decode(RedeemHistoryResponse.self, from: data!)
                let redeemHistoryList:[RedeemHistory] = redeemListResponse.walletHistory ?? []
                if redeemHistoryList.count > 0 {
                    for redeemHistoryItem in redeemHistoryList {
                        toArray.add(redeemHistoryItem)
                    }
                    completion(true)
                }else {
                    completion(false)
                }
            }catch {
                
            }
        }
    }
    class func parseInvoice(tripService:InvoiceTripService, tripDetail:InvoiceTrip,arrForInvocie:inout [[Invoice]])-> Bool {
        arrForInvocie.removeAll()
        arrForInvocie.append([])
        arrForInvocie.append([])
        arrForInvocie.append([])
        
        let distanceUnit = Utility.getDistanceUnit(unit: tripDetail.unit);
        
        let baseInvoiceTitle:String = ""
        let discountInvoiceTitle:String = "TXT_DISCOUNT".localized
        let totalInvoiceTitle:String = ""
        
        let promoValue = Invoice.init(sectionTitle: discountInvoiceTitle, title: "TXT_PROMO_BONUS".localized, subTitle: "", price: tripDetail.promoPayment.toCurrencyString())
        
        let referralValue = Invoice.init(sectionTitle: discountInvoiceTitle, title: "TXT_REFERRAL_BONUS".localized, subTitle: "", price: tripDetail.referralPayment.toCurrencyString())
        
        let taxSubTitle = tripService.tax.toString(places: 2) + " % "
        let taxValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_TAX".localized, subTitle: taxSubTitle, price: tripDetail.taxFee.toCurrencyString())
        
        
        
        
        let totalServiceFees = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_SERVICE_PRICE".localized, subTitle: "", price: tripDetail.totalServiceFees.toCurrencyString())
        
        let surgePriceSubTitle = "X " + tripDetail.surgeMultiplier.toString(places: 2)
        let surgePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_SURGE_PRICE".localized, subTitle: surgePriceSubTitle, price: tripDetail.surgeFee.toCurrencyString())
        
        let totalFixedFare = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_FIXED_RATE".localized, subTitle: "", price: tripDetail.fixedPrice.toCurrencyString())
        
        let tripTypeAmount = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_FIXED_RATE".localized, subTitle: "", price: tripDetail.tripTypeAmount.toCurrencyString())
        
        let totalTip = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_TIP".localized, subTitle: "", price: tripDetail.tipAmount.toCurrencyString())
        
        let totalToll = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_TOLL".localized, subTitle: "", price: tripDetail.tollAmount.toCurrencyString())
        
        var baseDistanceSubTitle = ""
        
        baseDistanceSubTitle = tripService.pricePerUnitDistance.toString(places: 1)  + "/" + distanceUnit
        
        var distancePriceValue = Invoice.init(title: "", subTitle: "", price: "")
                
        if tripService.is_use_distance_slot_calculation {
            if tripDetail.isFixedFare {
                distancePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_DISTANCE_PRICE".localized, subTitle: baseDistanceSubTitle, price: tripDetail.distanceCost.toCurrencyString())
            } else {
                distancePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "Distance Cost".localized, subTitle: "", price:tripService.basePrice.toCurrencyString())
            }
        } else {
            distancePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_DISTANCE_PRICE".localized, subTitle: baseDistanceSubTitle, price: tripDetail.distanceCost.toCurrencyString())
        }
        
        var baseTimeSubTitle = ""
        
        baseTimeSubTitle = tripService.priceForTotalTime.toString(places: 1)  + "/" + MeasureUnit.MINUTES
        
        let timePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_TIME_PRICE".localized, subTitle: baseTimeSubTitle, price:  tripDetail.timeCost.toCurrencyString())
        
        var baseWaitingTimeSubTitle = ""
        
        baseWaitingTimeSubTitle = tripService.priceForWaitingTime.toString(places: 1)  + "/" + MeasureUnit.MINUTES
        
        let totalWaitTimeCost = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_WAIT_TIME_COST".localized, subTitle: baseWaitingTimeSubTitle, price: tripDetail.waitingTimeCost.toCurrencyString())
        
        let userCityTaxSubTitle = tripService.userTax.toString(places: 1)  + " % "
        let totalUserCityTax = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_USER_CITY_TAX".localized, subTitle: userCityTaxSubTitle, price: tripDetail.userTaxFee.toCurrencyString())
        
        let providerCityTaxSubTitle = tripService.providerTax.toString(places: 1)  + " % "
        let totalProviderCityTax = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_PROVIDER_CITY_TAX".localized, subTitle: providerCityTaxSubTitle, price: tripDetail.providerTaxFee.toCurrencyString())
        
        let totalProviderMiscellaneousTax = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_PROVIDER_MISCELLANEOUS_TAX".localized, subTitle: "", price: tripDetail.providerMiscellaneousFee.toCurrencyString())
        
        let totalUserMiscellaneousTax = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_USER_MISCELLANEOUS_TAX".localized, subTitle: "", price: tripDetail.userMiscellaneousFee.toCurrencyString())
        
        let walletPayment = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_PAID_BY_WALLET".localized, subTitle: "", price: tripDetail.walletPayment.toCurrencyString())
        
        let totalRemainingPayment = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_REMAINING_TO_PAY".localized, subTitle: "", price:  tripDetail.remainingPayment.toCurrencyString())
        // ====
        //Code_By : Bhumita => git issue : issues_91
        if (tripDetail.tripType == TripType.NORMAL) {
            if tripDetail.isFixedFare && tripDetail.fixedPrice > 0{
                arrForInvocie[0].append(totalFixedFare)
            }
        }else if tripDetail.tripTypeAmount > 0{
            arrForInvocie[0].append(tripTypeAmount)
        }
        
        if !tripDetail.carRentalId.isEmpty() {
            let basePriceSubTitle =  tripService.basePriceTime.toString() + MeasureUnit.MINUTES + " & " + tripService.basePriceDistance.toString() + distanceUnit
            
            let basePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_BASE_PRICE".localized, subTitle: basePriceSubTitle, price:  tripService.basePrice.toCurrencyString())
            
            if !tripService.is_use_distance_slot_calculation {
                arrForInvocie[0].append(basePriceValue)
            }
            
        }else if tripService.basePrice > 0 && !tripDetail.isFixedFare{
            let basePriceSubTitle =  tripService.basePrice.toCurrencyString() + "/" + tripService.basePriceDistance.toString(places: 2) + distanceUnit
            
            let basePriceValue = Invoice.init(sectionTitle: baseInvoiceTitle, title: "TXT_BASE_PRICE".localized, subTitle: basePriceSubTitle, price:  tripService.basePrice.toCurrencyString())
            if !tripService.is_use_distance_slot_calculation {
                arrForInvocie[0].append(basePriceValue)
            }
        }
        if tripService.is_use_distance_slot_calculation {
            arrForInvocie[0].append(distancePriceValue)
        } else {
            if tripDetail.distanceCost > 0.0
            {
                arrForInvocie[0].append(distancePriceValue)
            }
        }
        if tripDetail.timeCost > 0.0 {
            arrForInvocie[0].append(timePriceValue)
        }
        if tripDetail.waitingTimeCost > 0.0 {
            arrForInvocie[0].append(totalWaitTimeCost)
        }
        if tripDetail.taxFee > 0.0 {
            arrForInvocie[0].append(taxValue)
        }
        if tripDetail.surgeFee > 0.0 {
            arrForInvocie[0].append(surgePriceValue)
        }
        if tripDetail.tipAmount > 0.0 {
            arrForInvocie[0].append(totalTip)
        }
        if tripDetail.tollAmount > 0.0 {
            arrForInvocie[0].append(totalToll)
        }
        if  tripDetail.userMiscellaneousFee > 0.0 {
            arrForInvocie[0].append(totalUserMiscellaneousTax)
        }
        if tripDetail.userTaxFee > 0.0 {
            arrForInvocie[0].append(totalUserCityTax)
        }
        if tripDetail.providerMiscellaneousFee > 0.0 {
            arrForInvocie[0].append(totalProviderMiscellaneousTax)
        }
        
        if tripDetail.providerTaxFee > 0.0 {
            arrForInvocie[0].append(totalProviderCityTax)
        }
        if tripDetail.referralPayment > 0.0 {
            arrForInvocie[1].append(referralValue)
        }
        if tripDetail.promoPayment > 0.0 {
            arrForInvocie[1].append(promoValue)
        }
        if tripDetail.walletPayment > 0.0 {
            arrForInvocie[0].append(walletPayment)
        }
        if tripDetail.remainingPayment > 0.0 {
            arrForInvocie[0].append(totalRemainingPayment)
        }
        if tripDetail.cardPayment > 0 {
            let paidBy = "TXT_PAID_BY_CARD".localized
            let paymentPaidBy = Invoice.init(sectionTitle: totalInvoiceTitle, title: paidBy, subTitle: "", price: tripDetail.cardPayment.toCurrencyString())
            arrForInvocie[0].append(paymentPaidBy)
        }
        if tripDetail.cashPayment > 0 {
            let paidBy =  "TXT_PAID_BY_CASH".localized
            let paymentPaidBy = Invoice.init(sectionTitle: totalInvoiceTitle, title: paidBy, subTitle: "", price: tripDetail.cashPayment.toCurrencyString())
            arrForInvocie[0].append(paymentPaidBy)
        }
        if arrForInvocie[2].count == 0 {
            arrForInvocie.remove(at: 2)
        }
        if arrForInvocie[1].count == 0 {
            arrForInvocie.remove(at: 1)
        }
        return true;
        // ====
    }
    
    class func parseLogout(response:[String:Any],data:Data?)-> Bool {
        if self.isSuccess(response: response, data: data) {
            let jsonDecoder = JSONDecoder()
            do {
                let isSuccess = try jsonDecoder.decode(ResponseModel.self, from: data!)
                if isSuccess.success {
                    preferenceHelper.setSessionToken("");
                    preferenceHelper.setUserId("");
                    ProviderSingleton.shared.clear()
                    preferenceHelper.removeImageBaseUrl()
                    APPDELEGATE.gotoLogin()
                    return true
                }else {
                    return false
                }
            }catch {
                return false
            }
        }else {
            return false
        }
    }
    
    class func parseCountries(_ response:[String:Any], data: Data? , toArray: NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, data: data, withSuccessToast: false, andErrorToast: true)) {
            let jsonDecoder = JSONDecoder()
            do {
                let coutries:CountriesResponse =  try jsonDecoder.decode(CountriesResponse.self, from: data!)
                toArray.removeAllObjects()
                let coutryList:[Country] = coutries.country
                if coutryList.count > 0 {
                    for country in coutryList {
                        toArray.add(country)
                    }
                    completion(true)
                }else {
                    completion(false)
                }
            }catch {
                completion(false)
            }
        }else {
            completion(false)
        }
    }
    
    //MARK:- Cities
    //MARK:- parseDocumentList is Success Or Not
    class func parseDocumentList(_ response: [String:Any],data:Data? ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, data: data, withSuccessToast: false, andErrorToast: true)) {
            let jsonDecoder = JSONDecoder()
            do {
                let documentResponse:DocumentsResponse =  try jsonDecoder.decode(DocumentsResponse.self, from: data!)
                toArray.removeAllObjects()
                for document in documentResponse.providerdocument {
                    toArray.add(document)
                }
                
                completion(true)
            }catch {
                completion(false)
            }
        }else {
            completion(false)
        }
    }

    //MARK: - parseWeatherResponse is Success Or Not
    static func isSuccess(response:[String:Any],data:Data?, withSuccessToast: Bool = false, andErrorToast: Bool = true,fromURL : String = "") -> Bool {
        if data != nil {
            let jsonDecoder = JSONDecoder()
            do {
                let isSuccess = try jsonDecoder.decode(ResponseModel.self, from: data!)
                if isSuccess.success {
                    if withSuccessToast {
                        DispatchQueue.main.async {
                            let messageCode:String = "MSG_CODE_" + String(isSuccess.message )
                            Utility.hideLoading()
                            Utility.showToast(message:messageCode.localized);
                        }
                    }
                    return true;
                } else {
                    let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode )
                    if (errorCode.compare("ERROR_CODE_451") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_474") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_630") == ComparisonResult.orderedSame ||
                        errorCode.compare("ERROR_CODE_479") == ComparisonResult.orderedSame) {
                        
                        Utility.hideLoading()
                        Utility.showToast(message: errorCode.localized);
                        preferenceHelper.setSessionToken("");
                        preferenceHelper.setUserId("");
                        APPDELEGATE.gotoLogin()
                        return false;
                    } else if andErrorToast {
                        DispatchQueue.main.async {
                            print("ROHIT fromURL :- \(fromURL)")
                            Utility.hideLoading()
                            Utility.showToast(message: errorCode.localized);
                        }
                    }
                    return false;
                }
            } catch {
                print("Exception in Response Parsing \(response)")
                return false;
            }
        } else {
            return false;
        }
    }
}
