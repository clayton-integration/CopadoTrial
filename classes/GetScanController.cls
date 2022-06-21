public class GetScanController {
    
    @InvocableMethod(label='Get Scan' description='Get Scan')
    public static List<GetScanResponse> getScan(List<GetScanRequest> request){
        
        ClaytonCopadoIntegration__c claytonCopado = ClaytonCopadoIntegration__c.getInstance();

        String accessToken = ClaytonTokenUtils.getAccessToken();
        String url = 'https://staging.claytonapp.com/api/workspaces/'+claytonCopado.AccountId__c+'/projects2/'+claytonCopado.ProjectId__c+'/scans/'+request.get(0).scanId; 
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(url);
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Content-Type','application/json');
        httpRequest.setHeader('Authorization','Bearer ' + accessToken);
        Http http = new Http();
        HttpResponse response = http.send(httpRequest);
        
        Scan scan = (Scan) JSON.deserialize(response.getBody(), Scan.class);

        GetScanResponse result = new GetScanResponse();
        result.id = scan.id;
        result.status = scan.status;
        result.htmlUrl = scan.html_url;
        result.sarifUrl = scan.sarif_url;
        result.result = scan.result;

        List<GetScanResponse> resultList = new List<GetScanResponse>();
        resultList.add(result);
        return resultList;
    }

    public class GetScanRequest{

        @InvocableVariable
        public String scanId;

    }

    public class GetScanResponse{
        
        @InvocableVariable
        public String id;

        @InvocableVariable
        public String status;

        @InvocableVariable
        public String htmlUrl;

        @InvocableVariable
        public String sarifUrl;

        @InvocableVariable
        public String result;

    }
}