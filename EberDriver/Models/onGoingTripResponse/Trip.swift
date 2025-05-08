//
//	Trip.swift
//
//	Create by MacPro3 on 24/9/2018
//	Copyright © 2018. All rights reserved.


//
//    Trip.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Trip : Codable {
    
    var  v : Int = 0
    var  id : String = ""
    var  acceptedTime : String = ""
    var  accessibility : [String] = []
    var  adminCurrency : String = ""
    var  adminCurrencycode : String = ""
    var  baseDistanceCost : Double = 0.0
    var  bearing : Double = 0.0
    var  cancelReason : String = ""
    var  cardPayment : Double = 0.0
    var  cashPayment : Double = 0.0
    var  cityId : String = ""
    var  completeDateTag : String = ""
    var  confirmedProvider : String = ""
    var  countryId : String = ""
    var  createdAt : String = ""
    var  currency : String = ""
    var  currencycode : String = ""
    var  currentProvider : String = ""
    var  destinationLocation : [Double] = [0.0,0.0]
    var  destinationAddress : String  =  ""
    var actualDestinationAddresses : [ActualDestinationAddresses] = []
    var destinationAddresses : [DestinationAddresses] = []
    var  distanceCost : Double = 0.0
    var  fixedPrice : Double = 0.0
    var  floor : Int = 0
    var  invoiceNumber : String = ""
    var  isAmountRefund : Bool = false
    var  isCancellationFee : Int = 0
    var  isFixedFare : Bool = false
    var  isMinFareUsed : Int = 0
    var  isPaid : Int = 0
    var  isPendingPayments : Int = 0
    var  isProviderAccepted : Int = 0
    var  isProviderEarningSetInWallet  : Bool = false
    var  isProviderInvoiceShow : Int = 0
    var  isProviderRated : Int = 0
    var  isProviderStatus : Int = 0
    var  isScheduleTrip : Bool = false
    var  isSurgeHours : Int = 0
    var  isTip : Bool = false
    var  isToll : Bool = false
    var  isTransfered : Bool = false
    var  isTripCancelled : Int = 0
    var  isTripCancelledByProvider : Int = 0
    var  isTripCancelledByUser : Double = 0.0
    var  isTripCompleted : Int = 0
    var  isTripEnd : Int = 0
    var  isTripInsideZoneQueue : Bool = false
    var  isUserInvoiceShow : Int = 0
    var  isUserRated : Int = 0
    var  noOfTimeSendRequest : Int = 0
    var  payToProvider : Double = 0.0
    var  paymentError : String = ""
    var  paymentErrorMessage : String = ""
    var  paymentMode : Int = 0
    var  promoPayment : Double = 0.0
    var  promoReferralAmount : Double = 0.0
    var  providerLocation : [Double] = [0.0,0.0]
    var  providerArrivedTime : String = ""
    var  providerFirstName : String = ""
    var  providerHaveCash : Double = 0.0
    var  providerId : String = ""
    var  providerIncomeSetInWallet  : Double = 0
    var  providerLanguage : [String] = []
    var  providerLastName : String = ""
    var  providerMiscellaneousFee : Double = 0.0
    var  providerServiceFees : Double = 0.0
    var  providerServiceFeesInAdminCurrency : Double = 0.0
    var  providerTaxFee : Double = 0.0
    var  providerTripEndTime : String = ""
    var  providerTripStartTime : String = ""
    var  providerType : Int = 0
    var  providerTypeId : String = ""
    var  providersIdThatRejectedTrip : [String] = []
    var  receivedTripFromGender : [String] = []
    var  referralPayment : Double = 0.0
    var  refundAmount : Double = 0.0
    var  remainingPayment : Double = 0.0
    var  roomNumber : String = ""
    var  scheduleStartTime : String = ""
    var  serverStartTimeForSchedule : String = ""
    var  serviceTotalInAdminCurrency : Double = 0.0
    var  serviceTypeId : String = ""
    var  sourceLocation : [Double] = [0.0,0.0]
    var  sourceAddress : String = ""
    var  speed : Double = 0.0
    var  surgeFee : Double = 0.0
    var  surgeMultiplier : Double = 0.0
    var  taxFee : Double = 0.0
    var  timeCost : Double = 0.0
    var  timezone : String = ""
    var  tipAmount : Double = 0.0
    var  tollAmount : Double = 0.0
    var  total : Double = 0.0
    var  totalAfterPromoPayment : Double = 0.0
    var  totalAfterReferralPayment : Double = 0.0
    var  totalAfterSurgeFees : Double = 0.0
    var  totalAfterTaxFees : Double = 0.0
    var  totalAfterWalletPayment : Double = 0.0
    var  totalDistance : Double = 0.0
    var  totalInAdminCurrency : Double = 0.0
    var  totalServiceFees : Double = 0.0
    var  totalTime : Double = 0.0
    var  totalWaitingTime : Int = 0
    var  totalWaitTime : Int = 0
    var  tripServiceCityTypeId : String = ""
    var  tripType : Int = 0
    var  tripTypeAmount : Double = 0.0
    var  uniqueId : Int = 0
    var  unit : Int = 0
    var  userCreateTime : String = ""
    var  userFirstName : String = ""
    var  userId : String = ""
    var  userLastName : String = ""
    var  carRentalId : String = ""
    var  userMiscellaneousFee : Double = 0.0
    var  userTaxFee : Double = 0.0
    var  userType : Int = 0
    var  userTypeId : String = ""
    var  waitingTimeCost : Double = 0.0
    var  walletPayment : Double = 0.0
    var isFavouriteProvider: Bool = false
    var is_otp_verification: Bool = false
    var confirmation_code: Int = 0
    var is_trip_bidding: Bool = false
    var bid_price: Double = 0
    var driver_max_bidding_limit: Double = 0
    var is_provider_assigned_by_dispatcher : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case v = "__v"
        case id = "_id"
        case isFavouriteProvider = "is_favourite_provider"
        case acceptedTime = "accepted_time"
        case accessibility = "accessibility"
        case adminCurrency = "admin_currency"
        case adminCurrencycode = "admin_currencycode"
        case baseDistanceCost = "base_distance_cost"
        case bearing = "bearing"
        case cancelReason = "cancel_reason"
        case cardPayment = "card_payment"
        case cashPayment = "cash_payment"
        case cityId = "city_id"
        case completeDateTag = "complete_date_tag"
        case confirmedProvider = "confirmed_provider"
        case countryId = "country_id"
        case createdAt = "created_at"
        case currency = "currency"
        case currencycode = "currency_code"
        case currentProvider = "current_provider"
        case destinationLocation = "destinationLocation"
        case destinationAddress = "destination_address"
        case distanceCost = "distance_cost"
        case fixedPrice = "fixed_price"
        case floor = "floor"
        case invoiceNumber = "invoice_number"
        case isAmountRefund = "is_amount_refund"
        case isCancellationFee = "is_cancellation_fee"
        case isFixedFare = "is_fixed_fare"
        case isMinFareUsed = "is_min_fare_used"
        case isPaid = "is_paid"
        case isPendingPayments = "is_pending_payments"
        case isProviderAccepted = "is_provider_accepted"
        case isProviderEarningSetInWallet  = "is_provider_earning_set_in_wallet"
        case isProviderInvoiceShow = "is_provider_invoice_show"
        case isProviderRated = "is_provider_rated"
        case isProviderStatus = "is_provider_status"
        case isScheduleTrip = "is_schedule_trip"
        case isSurgeHours = "is_surge_hours"
        case isTip = "is_tip"
        case isToll = "is_toll"
        case isTransfered = "is_transfered"
        case isTripCancelled = "is_trip_cancelled"
        case isTripCancelledByProvider = "is_trip_cancelled_by_provider"
        case isTripCancelledByUser = "is_trip_cancelled_by_user"
        case isTripCompleted = "is_trip_completed"
        case isTripEnd = "is_trip_end"
        case isTripInsideZoneQueue = "is_trip_inside_zone_queue"
        case isUserInvoiceShow = "is_user_invoice_show"
        case isUserRated = "is_user_rated"
        case noOfTimeSendRequest = "no_of_time_send_request"
        case payToProvider = "pay_to_provider"
        case paymentError = "payment_error"
        case paymentErrorMessage = "payment_error_message"
        case paymentMode = "payment_mode"
        case promoPayment = "promo_payment"
        case promoReferralAmount = "promo_referral_amount"
        case providerLocation = "providerLocation"
        case providerArrivedTime = "provider_arrived_time"
        case providerFirstName = "provider_first_name"
        case providerHaveCash = "provider_have_cash"
        case providerId = "provider_id"
        case providerIncomeSetInWallet  = "provider_income_set_in_wallet"
        case providerLanguage = "provider_language"
        case providerLastName = "provider_last_name"
        case providerMiscellaneousFee = "provider_miscellaneous_fee"
        case providerServiceFees = "provider_service_fees"
        case providerServiceFeesInAdminCurrency = "provider_service_fees_in_admin_currency"
        case providerTaxFee = "provider_tax_fee"
        case providerTripEndTime = "provider_trip_end_time"
        case providerTripStartTime = "provider_trip_start_time"
        case providerType = "provider_type"
        case providerTypeId = "provider_type_id"
        case providersIdThatRejectedTrip = "providers_id_that_rejected_trip"
        case receivedTripFromGender = "received_trip_from_gender"
        case referralPayment = "referral_payment"
        case refundAmount = "refund_amount"
        case remainingPayment = "remaining_payment"
        case roomNumber = "room_number"
        case scheduleStartTime = "schedule_start_time"
        case serverStartTimeForSchedule = "server_start_time_for_schedule"
        case serviceTotalInAdminCurrency = "service_total_in_admin_currency"
        case serviceTypeId = "service_type_id"
        case sourceLocation = "sourceLocation"
        case sourceAddress = "source_address"
        case speed = "speed"
        case surgeFee = "surge_fee"
        case surgeMultiplier = "surge_multiplier"
        case taxFee = "tax_fee"
        case timeCost = "time_cost"
        case timezone = "timezone"
        case tipAmount = "tip_amount"
        case tollAmount = "toll_amount"
        case total = "total"
        case totalAfterPromoPayment = "total_after_promo_payment"
        case totalAfterReferralPayment = "total_after_referral_payment"
        case totalAfterSurgeFees = "total_after_surge_fees"
        case totalAfterTaxFees = "total_after_tax_fees"
        case totalAfterWalletPayment = "total_after_wallet_payment"
        case totalDistance = "total_distance"
        case totalInAdminCurrency = "total_in_admin_currency"
        case totalServiceFees = "total_service_fees"
        case totalTime = "total_time"
        case totalWaitingTime = "total_waiting_time"
        case tripServiceCityTypeId = "trip_service_city_type_id"
        case tripType = "trip_type"
        case tripTypeAmount = "trip_type_amount"
        case uniqueId = "unique_id"
        case unit = "unit"
        case userCreateTime = "user_create_time"
        case userFirstName = "user_first_name"
        case userId = "user_id"
        case userLastName = "user_last_name"
        case userMiscellaneousFee = "user_miscellaneous_fee"
        case userTaxFee = "user_tax_fee"
        case userType = "user_type"
        case userTypeId = "user_type_id"
        case waitingTimeCost = "waiting_time_cost"
        case walletPayment = "wallet_payment"
        case totalWaitTime = "total_wait_time"
        case carRentalId = "car_rental_id"
        case destinationAddresses = "destination_addresses"
        case actualDestinationAddresses = "actual_destination_addresses"
        case is_otp_verification = "is_otp_verification"
        case confirmation_code = "confirmation_code"
        case is_trip_bidding = "is_trip_bidding"
        case bid_price = "bid_price"
        case driver_max_bidding_limit = "driver_max_bidding_limit"
        case is_provider_assigned_by_dispatcher = "is_provider_assigned_by_dispatcher"
    }
    
    init(from decoder: Decoder) throws {
        let  values = try decoder.container(keyedBy: CodingKeys.self)
        v = try values.decodeIfPresent(Int.self, forKey: .v) ?? 0
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        acceptedTime = try values.decodeIfPresent(String.self, forKey: .acceptedTime) ?? ""
        accessibility = try values.decodeIfPresent([String].self, forKey: .accessibility) ?? []
        carRentalId = try values.decodeIfPresent(String.self, forKey: .carRentalId) ?? ""
        adminCurrency = try values.decodeIfPresent(String.self, forKey: .adminCurrency) ?? ""
        adminCurrencycode = try values.decodeIfPresent(String.self, forKey: .adminCurrencycode) ?? ""
        baseDistanceCost = try values.decodeIfPresent(Double.self, forKey: .baseDistanceCost) ?? 0.0
        bearing = try values.decodeIfPresent(Double.self, forKey: .bearing) ?? 0.0
        cancelReason = try values.decodeIfPresent(String.self, forKey: .cancelReason) ?? ""
        cardPayment = try values.decodeIfPresent(Double.self, forKey: .cardPayment) ?? 0.0
        cashPayment = try values.decodeIfPresent(Double.self, forKey: .cashPayment) ?? 0.0
        cityId = try values.decodeIfPresent(String.self, forKey: .cityId) ?? ""
        completeDateTag = try values.decodeIfPresent(String.self, forKey: .completeDateTag) ?? ""
        confirmedProvider = try values.decodeIfPresent(String.self, forKey: .confirmedProvider) ?? ""
        countryId = try values.decodeIfPresent(String.self, forKey: .countryId) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        currencycode = try values.decodeIfPresent(String.self, forKey: .currencycode) ?? ""
        currentProvider = try values.decodeIfPresent(String.self, forKey: .currentProvider) ?? ""
        isFavouriteProvider = try values.decodeIfPresent(Bool.self, forKey: .isFavouriteProvider) ?? false
        destinationAddresses = try values.decodeIfPresent([DestinationAddresses].self, forKey: .destinationAddresses) ?? []
        actualDestinationAddresses = try values.decodeIfPresent([ActualDestinationAddresses].self, forKey: .actualDestinationAddresses) ?? []
        is_provider_assigned_by_dispatcher = try values.decodeIfPresent(Bool.self, forKey: .is_provider_assigned_by_dispatcher) ?? false
        do{
        destinationLocation = try values.decodeIfPresent([Double].self, forKey: .destinationLocation) ?? [0.0,0.0]
        }
        catch
        {
        destinationLocation =  [0.0,0.0]
        }
        if destinationLocation.isEmpty
        {
        destinationLocation =  [0.0,0.0]
        }
        destinationAddress = try values.decodeIfPresent(String.self, forKey: .destinationAddress) ?? ""
        distanceCost = try values.decodeIfPresent(Double.self, forKey: .distanceCost) ?? 0.0
        fixedPrice = try values.decodeIfPresent(Double.self, forKey: .fixedPrice) ?? 0.0
        floor = try values.decodeIfPresent(Int.self, forKey: .floor) ?? 0
        invoiceNumber = try values.decodeIfPresent(String.self, forKey: .invoiceNumber) ?? ""
        isAmountRefund = try values.decodeIfPresent(Bool.self, forKey: .isAmountRefund) ?? false
        isCancellationFee = try values.decodeIfPresent(Int.self, forKey: .isCancellationFee) ?? 0
        isFixedFare = try values.decodeIfPresent(Bool.self, forKey: .isFixedFare) ?? false
        isMinFareUsed = try values.decodeIfPresent(Int.self, forKey: .isMinFareUsed) ?? 0
        isPaid = try values.decodeIfPresent(Int.self, forKey: .isPaid) ?? 0
        isPendingPayments = try values.decodeIfPresent(Int.self, forKey: .isPendingPayments) ?? 0
        isProviderAccepted = try values.decodeIfPresent(Int.self, forKey: .isProviderAccepted) ?? 0
        isProviderEarningSetInWallet  = try values.decodeIfPresent(Bool.self, forKey: .isProviderEarningSetInWallet) ?? false
        isProviderInvoiceShow = try values.decodeIfPresent(Int.self, forKey: .isProviderInvoiceShow) ?? 0
        isProviderRated = try values.decodeIfPresent(Int.self, forKey: .isProviderRated) ?? 0
        isProviderStatus = try values.decodeIfPresent(Int.self, forKey: .isProviderStatus) ?? 0
        isScheduleTrip = try values.decodeIfPresent(Bool.self, forKey: .isScheduleTrip) ?? false
        totalWaitTime = try values.decodeIfPresent(Int.self, forKey: .totalWaitTime) ?? 0
        isSurgeHours = try values.decodeIfPresent(Int.self, forKey: .isSurgeHours) ?? 0
        isTip = try values.decodeIfPresent(Bool.self, forKey: .isTip) ?? false
        isToll = try values.decodeIfPresent(Bool.self, forKey: .isToll) ?? false
        isTransfered = try values.decodeIfPresent(Bool.self, forKey: .isTransfered) ?? false
        isTripCancelled = try values.decodeIfPresent(Int.self, forKey: .isTripCancelled) ?? 0
        isTripCancelledByProvider = try values.decodeIfPresent(Int.self, forKey: .isTripCancelledByProvider) ?? 0
        isTripCancelledByUser = try values.decodeIfPresent(Double.self, forKey: .isTripCancelledByUser) ?? 0.0
        isTripCompleted = try values.decodeIfPresent(Int.self, forKey: .isTripCompleted) ?? 0
        isTripEnd = try values.decodeIfPresent(Int.self, forKey: .isTripEnd) ?? 0
        isTripInsideZoneQueue = try values.decodeIfPresent(Bool.self, forKey: .isTripInsideZoneQueue) ?? false
        isUserInvoiceShow = try values.decodeIfPresent(Int.self, forKey: .isUserInvoiceShow) ?? 0
        isUserRated = try values.decodeIfPresent(Int.self, forKey: .isUserRated) ?? 0
        noOfTimeSendRequest = try values.decodeIfPresent(Int.self, forKey: .noOfTimeSendRequest) ?? 0
        payToProvider = try values.decodeIfPresent(Double.self, forKey: .payToProvider) ?? 0.0
        paymentError = try values.decodeIfPresent(String.self, forKey: .paymentError) ?? ""
        paymentErrorMessage = try values.decodeIfPresent(String.self, forKey: .paymentErrorMessage) ?? ""
        paymentMode = try values.decodeIfPresent(Int.self, forKey: .paymentMode) ?? 0
        promoPayment = try values.decodeIfPresent(Double.self, forKey: .promoPayment) ?? 0.0
        promoReferralAmount = try values.decodeIfPresent(Double.self, forKey: .promoReferralAmount) ?? 0.0
        providerLocation = try values.decodeIfPresent([Double].self, forKey: .providerLocation) ?? [0.0,0.0]
        providerArrivedTime = try values.decodeIfPresent(String.self, forKey: .providerArrivedTime) ?? ""
        providerFirstName = try values.decodeIfPresent(String.self, forKey: .providerFirstName) ?? ""
        providerHaveCash = try values.decodeIfPresent(Double.self, forKey: .providerHaveCash) ?? 0.0
        providerId = try values.decodeIfPresent(String.self, forKey: .providerId) ?? ""
        providerIncomeSetInWallet  = try values.decodeIfPresent(Double.self, forKey: .providerIncomeSetInWallet) ?? 0.0
        providerLanguage = try values.decodeIfPresent([String].self, forKey: .providerLanguage) ?? []
        providerLastName = try values.decodeIfPresent(String.self, forKey: .providerLastName) ?? ""
        providerMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .providerMiscellaneousFee) ?? 0.0
        providerServiceFees = try values.decodeIfPresent(Double.self, forKey: .providerServiceFees) ?? 0.0
        providerServiceFeesInAdminCurrency = try values.decodeIfPresent(Double.self, forKey: .providerServiceFeesInAdminCurrency) ?? 0.0
        providerTaxFee = try values.decodeIfPresent(Double.self, forKey: .providerTaxFee) ?? 0.0
        providerTripEndTime = try values.decodeIfPresent(String.self, forKey: .providerTripEndTime) ?? ""
        providerTripStartTime = try values.decodeIfPresent(String.self, forKey: .providerTripStartTime) ?? ""
        providerType = try values.decodeIfPresent(Int.self, forKey: .providerType) ?? 0
        providerTypeId = try values.decodeIfPresent(String.self, forKey: .providerTypeId) ?? ""
        providersIdThatRejectedTrip = try values.decodeIfPresent([String].self, forKey: .providersIdThatRejectedTrip) ?? []
        receivedTripFromGender = try values.decodeIfPresent([String].self, forKey: .receivedTripFromGender) ?? []
        referralPayment = try values.decodeIfPresent(Double.self, forKey: .referralPayment) ?? 0.0
        refundAmount = try values.decodeIfPresent(Double.self, forKey: .refundAmount) ?? 0.0
        remainingPayment = try values.decodeIfPresent(Double.self, forKey: .remainingPayment) ?? 0.0
        roomNumber = try values.decodeIfPresent(String.self, forKey: .roomNumber) ?? ""
        scheduleStartTime = try values.decodeIfPresent(String.self, forKey: .scheduleStartTime) ?? ""
        serverStartTimeForSchedule = try values.decodeIfPresent(String.self, forKey: .serverStartTimeForSchedule) ?? ""
        serviceTotalInAdminCurrency = try values.decodeIfPresent(Double.self, forKey: .serviceTotalInAdminCurrency) ?? 0.0
        serviceTypeId = try values.decodeIfPresent(String.self, forKey: .serviceTypeId) ?? ""
        sourceLocation = try values.decodeIfPresent([Double].self, forKey: .sourceLocation) ?? [0.0,0.0]
        sourceAddress = try values.decodeIfPresent(String.self, forKey: .sourceAddress) ?? ""
        speed = try values.decodeIfPresent(Double.self, forKey: .speed) ?? 0.0
        surgeFee = try values.decodeIfPresent(Double.self, forKey: .surgeFee) ?? 0.0
        surgeMultiplier = try values.decodeIfPresent(Double.self, forKey: .surgeMultiplier) ?? 0.0
        taxFee = try values.decodeIfPresent(Double.self, forKey: .taxFee) ?? 0.0
        timeCost = try values.decodeIfPresent(Double.self, forKey: .timeCost) ?? 0.0
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone) ?? ""
        tipAmount = try values.decodeIfPresent(Double.self, forKey: .tipAmount) ?? 0.0
        tollAmount = try values.decodeIfPresent(Double.self, forKey: .tollAmount) ?? 0.0
        total = try values.decodeIfPresent(Double.self, forKey: .total) ?? 0.0
        totalAfterPromoPayment = try values.decodeIfPresent(Double.self, forKey: .totalAfterPromoPayment) ?? 0.0
        totalAfterReferralPayment = try values.decodeIfPresent(Double.self, forKey: .totalAfterReferralPayment) ?? 0.0
        totalAfterSurgeFees = try values.decodeIfPresent(Double.self, forKey: .totalAfterSurgeFees) ?? 0.0
        totalAfterTaxFees = try values.decodeIfPresent(Double.self, forKey: .totalAfterTaxFees) ?? 0.0
        totalAfterWalletPayment = try values.decodeIfPresent(Double.self, forKey: .totalAfterWalletPayment) ?? 0.0
        totalDistance = try values.decodeIfPresent(Double.self, forKey: .totalDistance) ?? 0.0
        totalInAdminCurrency = try values.decodeIfPresent(Double.self, forKey: .totalInAdminCurrency) ?? 0.0
        totalServiceFees = try values.decodeIfPresent(Double.self, forKey: .totalServiceFees) ?? 0.0
        totalTime = try values.decodeIfPresent(Double.self, forKey: .totalTime) ?? 0.0
        totalWaitingTime = try values.decodeIfPresent(Int.self, forKey: .totalWaitingTime) ?? 0
        tripServiceCityTypeId = try values.decodeIfPresent(String.self, forKey: .tripServiceCityTypeId) ?? ""
        tripType = try values.decodeIfPresent(Int.self, forKey: .tripType) ?? 0
        tripTypeAmount = try values.decodeIfPresent(Double.self, forKey: .tripTypeAmount) ?? 0.0
        uniqueId = try values.decodeIfPresent(Int.self, forKey: .uniqueId) ?? 0
        unit = try values.decodeIfPresent(Int.self, forKey: .unit) ?? 0
        userCreateTime = try values.decodeIfPresent(String.self, forKey: .userCreateTime) ?? ""
        userFirstName = try values.decodeIfPresent(String.self, forKey: .userFirstName) ?? ""
        userId = try values.decodeIfPresent(String.self, forKey: .userId) ?? ""
        userLastName = try values.decodeIfPresent(String.self, forKey: .userLastName) ?? ""
        userMiscellaneousFee = try values.decodeIfPresent(Double.self, forKey: .userMiscellaneousFee) ?? 0.0
        userTaxFee = try values.decodeIfPresent(Double.self, forKey: .userTaxFee) ?? 0.0
        userType = try values.decodeIfPresent(Int.self, forKey: .userType) ?? 0
        userTypeId = try values.decodeIfPresent(String.self, forKey: .userTypeId) ?? ""
        waitingTimeCost = try values.decodeIfPresent(Double.self, forKey: .waitingTimeCost) ?? 0.0
        walletPayment = try values.decodeIfPresent(Double.self, forKey: .walletPayment) ?? 0.0
        is_otp_verification = try values.decodeIfPresent(Bool.self, forKey: .is_otp_verification) ?? false
        confirmation_code = try values.decodeIfPresent(Int.self, forKey: .confirmation_code) ?? 0
        is_trip_bidding = try values.decodeIfPresent(Bool.self, forKey: .is_trip_bidding) ?? false
        bid_price = try values.decodeIfPresent(Double.self, forKey: .bid_price) ?? 0
        driver_max_bidding_limit = try values.decodeIfPresent(Double.self, forKey: .driver_max_bidding_limit) ?? 0
    }
    
    init() {}
}

struct DestinationAddresses : Codable {

    
    var location : [Double] = []
    var address : String = ""


    enum CodingKeys: String, CodingKey {
        case location = "location"
        case address = "address"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent([Double].self, forKey: .location) ?? []
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
    }


}

struct ActualDestinationAddresses : Codable {

    
    var location : [Double] = []
    var address : String = ""
    var arrivedTime : String = ""
    var startTime : String = ""
    var totalTime : Int = 0
    var waitingTime : Int = 0

    enum CodingKeys: String, CodingKey {
        case location = "location"
        case address = "address"
        case arrivedTime = "arrived_time"
        case startTime = "start_time"
        case totalTime = "total_time"
        case waitingTime = "waiting_time"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent([Double].self, forKey: .location) ?? []
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        arrivedTime = try values.decodeIfPresent(String.self, forKey: .arrivedTime) ?? ""
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? ""
        totalTime = try values.decodeIfPresent(Int.self, forKey: .totalTime) ?? 0
        waitingTime = try values.decodeIfPresent(Int.self, forKey: .waitingTime) ?? 0
    }


}
