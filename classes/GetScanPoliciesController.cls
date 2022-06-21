global class GetScanPoliciesController {
    
    @InvocableMethod(label='Get Scan Policies' description='Get Scan Policies')
    global static List<ScanPoliciesResponse> getScanPolicies(List<ScanPoliciesRequest> request){
        
        ClaytonCopadoIntegration__c claytonCopado = ClaytonCopadoIntegration__c.getInstance();

        String accessToken = ClaytonTokenUtils.getAccessToken();
        String url = 'https://staging.claytonapp.com/api/workspaces/' + claytonCopado.AccountId__c +
                        '/projects2/' + claytonCopado.ProjectId__c + 
                        '/scans/' + request.get(0).scanId + 
                        '/policies';
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(url);
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Content-Type','application/json');
        httpRequest.setHeader('Authorization','Bearer ' + accessToken);
        Http http = new Http();
        HttpResponse response = http.send(httpRequest);
        
        List<ScanPolicy> scanPolicies = (List<ScanPolicy>) JSON.deserialize(response.getBody(), List<ScanPolicy>.class);

        List<ScanPoliciesResponse> resultList = new List<ScanPoliciesResponse>();
        ScanPoliciesResponse scanPoliciesResponse = new ScanPoliciesResponse();
        scanPoliciesResponse.scanPolicies = scanPolicies;

        resultList.add(scanPoliciesResponse);

        return resultList;
    }

    global class ScanPoliciesRequest{

        @InvocableVariable
        global String scanId;

    }

    global class ScanPoliciesResponse {

        @InvocableVariable
        global List<ScanPolicy> scanPolicies;

    }

}