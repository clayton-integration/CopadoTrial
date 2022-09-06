global class Concur extends Auth.AuthProviderPluginClass {
               
               public String redirectUrl; // use this URL for the endpoint that the authentication provider calls back to for configuration
               private String key;
               private String secret;
               private String authUrl;    // application redirection to the Concur website for authentication and authorization
               private String accessTokenUrl; // uri to get the new access token from concur  using the GET verb
               private String customMetadataTypeApiName; // api name for the custom metadata type created for this auth provider
               private String userAPIUrl; // api url to access the user in concur
               private String userAPIVersionUrl; // version of the user api url to access data from concur
               
       
               global String getCustomMetadataType() {
                   return 'copado__Copado_Setting__mdt';
               }
       
               global PageReference initiate(Map<string,string> authProviderConfiguration, String stateToPropagate) {
                   authUrl = 'https://app.clayton.io/oauth2/authorize';
                   key = '9e898da71d13f1df3e3249879e1c958e';
                   redirectUrl = 'https://claytoncopatrial.my.salesforce.com/services/authcallback/clayton_2';
                   //Here the developer can build up a request of some sort
                   //Ultimately they’ll return a URL where we will redirect the user
                   System.debug(redirectUrl);
                   String url = authUrl + '?response_type=code&client_id='+ key +'&scope=workspace&redirect_uri='+ redirectUrl + '&state=' + stateToPropagate;
                   return new PageReference(url);
                }
        
               global Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) {
                   //Here, the developer will get the callback with actual protocol.  
                   //Their responsibility is to return a new object called AuthProviderToken
                   //This will contain an optional accessToken and refreshToken
                   key = '9e898da71d13f1df3e3249879e1c958e';
                   secret = '53e75b97e816b4593b46eda435ec6f7c6006a785fe1cd8c99250a809e3dcb8911ad7c9332c85be462099ea1396ec5afe502570287389e3746be78bf8fdd55635';
                   accessTokenUrl = 'https://app.clayton.io/oauth2/token';
                   System.debug(key);
                   System.debug(secret);
                   System.debug(accessTokenUrl);
                   
                   Map<String,String> queryParams = state.queryParameters;
              
                   String code = queryParams.get('code');
                   System.debug(code);
                   String sfdcState = queryParams.get('state');
                   System.debug(sfdcState);
                   
                   Blob headerValue = Blob.valueOf(key + ':' + secret);
                   String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                   redirectUrl = 'https://claytoncopatrial.my.salesforce.com/services/authcallback/clayton_2';
        
                   HttpRequest req = new HttpRequest();
                   String url = accessTokenUrl+'?grant_type=authorization_code&code=' + code + '&client_id=' + key + '&redirect_uri=' + redirectUrl ;
                   req.setEndpoint(url);
                   req.setHeader('Content-Type','application/json');
                   req.setHeader('Authorization',authorizationHeader);
                   req.setMethod('POST');
                   
                   Http http = new Http();
                   HTTPResponse res = http.send(req);
                   String responseBody = res.getBody();
                   
                   System.debug('resp'+responseBody);
                   
                   String accessToken = getTokenValueFromResponse(responseBody, 'access_token');
                   //Parse access token value
                   String refreshToken = getTokenValueFromResponse(responseBody, 'refresh_token');
 
                     System.debug('accessToken'+accessToken);
                     System.debug('refreshToken'+refreshToken);
                   return new Auth.AuthProviderTokenResponse('Concur', accessToken, 'refreshToken', sfdcState);
                   //don’t hard-code the refresh token value!
                }
    
    
                 global Auth.UserData  getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) { 
                     String id = 'user-id';
                     String fname = 'first name';
                     String lname = 'last name';
                     String flname = 'full name';
                     String uname = 'email@app.com';
                     String locale = 'us';
                     Map<String,String> provMap = new Map<String,String>();
                     provMap.put('what1', 'noidea1');
                     provMap.put('what2', 'noidea2');
                     return new Auth.UserData(id, fname, lname, flname, uname,
                          'what', locale, null, 'Concur', null, provMap);
                }
                
                private String getTokenValueFromResponse(String response, String ns) {
                   Map<String, String> values = (Map<String, String>) JSON.deserialize(response, Map<String, String>.class);
                   return values.get(ns);
                }  
    
}