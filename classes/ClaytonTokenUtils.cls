public with sharing class ClaytonTokenUtils {

    public static String getAccessToken() {

        ClaytonCopadoIntegration__c claytonCopado = ClaytonCopadoIntegration__c.getInstance();

        String OAutAuthURL = 'https://staging.claytonapp.com/oauth/token'; 
        HttpRequest request = new HttpRequest();
        request.setEndpoint( OAutAuthURL );
        request.setMethod('POST');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        String scope = EncodingUtil.urlEncode('read write','UTF-8');
        String username = EncodingUtil.urlEncode(claytonCopado.ApiUser__c,'UTF-8');
        String password = EncodingUtil.urlEncode(claytonCopado.ApiPassword__c,'UTF-8');

        String body = 'grant_type=password&client_id='+claytonCopado.ClientId__c+'&client_secret='+claytonCopado.ClientSecret__c+'&username='+username+'&password='+password+'&scope='+scope;
        
        request.setBody(body);
        Http http = new Http();
        HttpResponse response = http.send(request);
        ClaytonToken claytonToken = (ClaytonToken) JSON.deserialize(response.getBody(), ClaytonToken.class);
        return claytonToken.access_token;

    }

}