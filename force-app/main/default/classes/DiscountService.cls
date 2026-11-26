/**
 * @description Provides the discount calculation entry point for customer tiers.
 * The service resolves the appropriate pricing strategy and executes it using a pricing context.
 */
public class DiscountService {
    private static final Map<String, Type> STRATEGY_MAP = new Map<String, Type>{
		'Non-Profit' => NonProfitDiscount.class,
        'Enterprise' => EnterpriseDiscount.class,
        'Partner'    => PartnerDiscount.class,
        'Standard'   => StandardDiscount.class
    };

    /**
     * Applies the appropriate discount strategy for the supplied customer tier.
     *
     * @param tier The customer tier used to resolve a discount strategy.
     * @param amount The base amount to which the discount is applied.
     * @return The discounted amount after the strategy executes.
     */
    public static Decimal applyDiscount(String tier, Decimal amount) {
        Type strategyType = STRATEGY_MAP.get(tier);
        if (strategyType == null) {
            strategyType = StandardDiscount.class;
        }
        
        // Only the needed class is instantiated
        IDiscountStrategy strategy = (IDiscountStrategy) strategyType.newInstance();
        PricingContext context = new PricingContext(strategy);
        return context.executeDiscount(amount);
    }
}