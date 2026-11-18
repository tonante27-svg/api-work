/**
 * @description Contract for discount calculation strategies.
 */
public interface IDiscountStrategy {
  /**
   * @description Calculates the discount amount for the provided total amount.
   * @param amount The amount to evaluate for discount.
   * @return The calculated discount amount.
   */
  Decimal calculateDiscount(Decimal amount);
}