String jsonString = '{"paymentId":"12345","amount":100.50,"status":"Completed"}';
PaymentWrapper pw = (PaymentWrapper) JSON.deserialize(jsonString, PaymentWrapper.class);
system.debug(pw.paymentId);
system.debug(pw.amount);
system.debug(pw.status);    