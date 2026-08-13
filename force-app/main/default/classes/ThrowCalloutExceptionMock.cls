public class ThrowCalloutExceptionMock implements HttpCalloutMock {
	public HttpResponse respond(HttpRequest req) {
        // This is the "magic" line that forces your utility class into the catch block
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        e.setMessage('Unauthorized endpoint or timeout');
        throw e;
    }
}