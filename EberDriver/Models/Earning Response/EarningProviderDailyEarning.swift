
import Foundation



struct EarningProviderDailyEarning : Codable {
    
    var id : String = ""
    var currency : String = ""
    var serviceTotal : Double = 0.0
    var statementNumber : String?
    var totalAddedWalletAmount : Double = 0.0
    var totalDeductWalletAmount : Double = 0.0
    var totalDistance : Double = 0.0
    var totalPaidInWalletPayment : Double = 0.0
    var totalPayToProvider : Double = 0.0
    var totalProviderHaveCash : Double = 0.0
    var totalProviderMiscellaneousFees : Double = 0.0
    var totalProviderServiceFees : Double = 0.0
    var totalProviderTaxFees : Double = 0.0
    var totalServiceSurgeFees : Double = 0.0
    var totalTime : Double = 0.0
    var totalTipAmount : Double = 0.0
    var totalTollAmount : Double = 0.0
    var totalTransferredAmount : Double = 0.0
    var totalWaitingTime : Double = 0.0
    var unit : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case currency = "currency"
        case serviceTotal = "service_total"
        case statementNumber = "statement_number"
        case totalAddedWalletAmount = "total_added_wallet_amount"
        case totalDeductWalletAmount = "total_deduct_wallet_amount"
        case totalDistance = "total_distance"
        case totalPaidInWalletPayment = "total_paid_in_wallet_payment"
        case totalPayToProvider = "total_pay_to_provider"
        case totalProviderHaveCash = "total_provider_have_cash"
        case totalProviderMiscellaneousFees = "total_provider_miscellaneous_fees"
        case totalProviderServiceFees = "total_provider_service_fees"
        case totalProviderTaxFees = "total_provider_tax_fees"
        case totalServiceSurgeFees = "total_service_surge_fees"
        case totalTime = "total_time"
        case totalTipAmount = "total_tip_amount"
        case totalTollAmount = "total_toll_amount"
        case totalTransferredAmount = "total_transferred_amount"
        case totalWaitingTime = "total_waiting_time"
        case unit = "unit"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        currency = try values.decodeIfPresent(String.self, forKey: .currency) ?? ""
        serviceTotal = try values.decodeIfPresent(Double.self, forKey: .serviceTotal) ?? 0.0
        statementNumber = try values.decodeIfPresent(String.self, forKey: .statementNumber) ?? ""
        totalAddedWalletAmount = try values.decodeIfPresent(Double.self, forKey: .totalAddedWalletAmount) ?? 0.0
        totalDeductWalletAmount = try values.decodeIfPresent(Double.self, forKey: .totalDeductWalletAmount) ?? 0.0
        totalDistance = try values.decodeIfPresent(Double.self, forKey: .totalDistance) ?? 0.0
        totalPaidInWalletPayment = try values.decodeIfPresent(Double.self, forKey: .totalPaidInWalletPayment) ?? 0.0
        totalPayToProvider = try values.decodeIfPresent(Double.self, forKey: .totalPayToProvider) ?? 0.0
        totalProviderHaveCash = try values.decodeIfPresent(Double.self, forKey: .totalProviderHaveCash) ?? 0.0
        totalProviderMiscellaneousFees = try values.decodeIfPresent(Double.self, forKey: .totalProviderMiscellaneousFees) ?? 0.0
        totalProviderServiceFees = try values.decodeIfPresent(Double.self, forKey: .totalProviderServiceFees) ?? 0.0
        totalProviderTaxFees = try values.decodeIfPresent(Double.self, forKey: .totalProviderTaxFees) ?? 0.0
        totalServiceSurgeFees = try values.decodeIfPresent(Double.self, forKey: .totalServiceSurgeFees) ?? 0.0
        totalTime = try values.decodeIfPresent(Double.self, forKey: .totalTime) ?? 0.0
        totalTipAmount = try values.decodeIfPresent(Double.self, forKey: .totalTipAmount) ?? 0.0
        totalTollAmount = try values.decodeIfPresent(Double.self, forKey: .totalTollAmount) ?? 0.0
        totalTransferredAmount = try values.decodeIfPresent(Double.self, forKey: .totalTransferredAmount) ?? 0.0
        totalWaitingTime = try values.decodeIfPresent(Double.self, forKey: .totalWaitingTime) ?? 0.0
        unit = try values.decodeIfPresent(Int.self, forKey: .unit) ?? 0
    }
}
