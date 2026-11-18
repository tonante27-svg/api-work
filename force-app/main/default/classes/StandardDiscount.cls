/**
 * @description Applies a standard 5% disßcount to an amount.
 */
public with sharing class StandardDiscount implements IDiscountStrategy {
    /**
     * @description Calculates the standard discount for the supplied amount.
     * @param amount The amount on which the discount should be applied.
     * @return The calculated discount value.
     */
    public Decimal calculateDiscount(Decimal amount) {
        return amount * 0.05;
    }
}