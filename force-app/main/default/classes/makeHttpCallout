public without sharing class makeHttpCallout {

    public static void makeHttpCalloutGet() {
        // Define the URL to call
        String endpoint = 'https://postman-echo.com/get?foo1=bar1&foo2=bar2';

        // Create an HTTP request object
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        // Create an HTTP object to send the request
        Http http = new Http();

        try {
            // Send the request and capture the response
            HttpResponse response = http.send(request);

            // Check if the callout was successful
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug(responseBody);
            } else {
                System.debug('HTTP Callout failed with status code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('HTTP Callout Exception: ' + e.getMessage());
        }
    }
}
