/**
 * Applies the nonprofit discount strategy.
 */
public with sharing class NonProfitDiscount implements IDiscountStrategy{
    /**
     * Calculates a 25 percent discount on the supplied amount.
     *
     * @param amount the amount to discount
     * @return the discount amount
     */
    public Decimal calculateDiscount(Decimal amount) {
        return amount * 0.25;
    }
}
