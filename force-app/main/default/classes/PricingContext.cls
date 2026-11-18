/**
 * Represents the pricing context used to apply a discount strategy.
 */
public class PricingContext {
    private IDiscountStrategy strategy;

    /**
     * Constructs a pricing context with a discount strategy.
     * @param strategy The discount strategy to be applied.
     */
    public PricingContext(IDiscountStrategy strategy) {
        if (strategy == null) {
            throw new IllegalArgumentException(
                'Discount strategy cannot be null'
            );
        }

        this.strategy = strategy;
    }

    /**
     * Executes the configured discount strategy for the provided amount.
     * @param amount The original amount before discount.
     * @return The discounted amount.
     */
    public Decimal executeDiscount(Decimal amount) {
        return strategy.calculateDiscount(amount);
    }
}