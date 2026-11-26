public with sharing class PartnerDiscount implements IDiscountStrategy{
    public Decimal calculateDiscount(Decimal amount) {
        return amount * 0.15;
    }
}