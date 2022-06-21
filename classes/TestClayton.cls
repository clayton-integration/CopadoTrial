Public class TestClayton{
    public static void callRestClassinDevOrg(){
        
        String OAutAuthURL = 'https://staging.claytonapp.com/oauth/token'; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint( OAutAuthURL );
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        
        String clientId = 'clientapp';
        String clientSecret = '123456';
        String scope = EncodingUtil.urlEncode('read write','UTF-8');
        String username = EncodingUtil.urlEncode('andrea-pellegatta','UTF-8');
        String password = EncodingUtil.urlEncode('ABCDEFGh123!','UTF-8');
        
        //---Username-Pwd OAuth Authentication Flow
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password+'&scope='+scope;
        
        req.setBody(reqBody);
        Http http = new Http();
        HttpResponse response = http.send(req);
        ClaytonToken claytonToken = (ClaytonToken) JSON.deserialize(response.getBody(), ClaytonToken.class);
        System.debug('Access Token :: '+ claytonToken.access_token);
    }
}