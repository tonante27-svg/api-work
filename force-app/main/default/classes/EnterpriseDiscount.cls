/**
 * Applies the enterprise discount strategy.
 */
public with sharing class EnterpriseDiscount implements IDiscountStrategy{
    public Decimal calculateDiscount(Decimal amount) {
        return amount * 0.20;
    }
}