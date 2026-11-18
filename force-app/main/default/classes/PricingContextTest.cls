@IsTest
private class PricingContextTest{

    private class StubDiscountStrategy implements IDiscountStrategy{
        public Decimal amountToProcess;
        public Boolean wasCalled = false;


        /**
         * Returns the amount provided to the stub strategy.
         * @param amountToProcess The amount to process.
         * @return The amount provided to the strategy.
         */
        public Decimal calculateDiscount(Decimal amountToProcess){
            wasCalled = true;
            return amountToProcess;
        }
    }


    @IsTest
    static void testContextDelegatesToInjectedStrategy() {

        //Arrange
        StubDiscountStrategy stubStrategy = new StubDiscountStrategy();
        Decimal amountToProcess = 150.35;

        // Act: Inject the stub into the 
        PricingContext context = new PricingContext(stubStrategy);
        Decimal discount = context.executeDiscount(amountToProcess);
        system.debug('=== DISCOUNT: ' + discount);
        //Assert
        Assert.isTrue(stubStrategy.wasCalled, 'The strategy calculateRate method should have been invoked.');
        Assert.areEqual(
            amountToProcess,
            discount,
            'The context should return the value supplied by the strategy.'
        );
    }

    @IsTest
    static void testNullStrategyThrowsException() {
        // Arrange, Act & Assert
        Boolean exceptionCaught = false;

        Test.startTest();
        try {
            PricingContext context = new PricingContext(null);
            context.executeDiscount(90.0);
        } catch (IllegalArgumentException e) {
            exceptionCaught = true;
            Assert.isTrue(e.getMessage().contains('Discount strategy cannot be null'), 'Exception message should match.');
        }
        Test.stopTest();

        Assert.isTrue(exceptionCaught, 'An IllegalArgumentException should have been thrown for a null strategy.');
    }

    @IsTest
    static void testConcreteStrategyIntegration() {
        // Optional: Test actual concrete implementation without mocking to ensure end-to-end correctness
        IDiscountStrategy notierStrategy = new StandardDiscount();
        PricingContext context = new PricingContext(notierStrategy);

        Decimal discounted = context.executeDiscount(100.0); // 100 * $.050
        
        Assert.areEqual(5.00, discounted, 'Standard discount is only 5%.');
    }
}
