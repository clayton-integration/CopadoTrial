public with sharing class ScanBranchController {
    
    @InvocableMethod(label='Scan branch' description='Scan by branch')
    public static List<ScanBranchResponse> scanByBranch(List<ScanBranchRequest> request){
        
        ClaytonCopadoIntegration__c claytonCopado = ClaytonCopadoIntegration__c.getInstance();

        String accessToken = ClaytonTokenUtils.getAccessToken();
        String jsonBody = '{"branch": "'+request.get(0).branchName+'","type": "AUTO","stealth_mode": false}';
        String url = 'https://staging.claytonapp.com/api/workspaces/'+claytonCopado.AccountId__c+'/projects2/'+claytonCopado.ProjectId__c+'/scans/by_branch'; 
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(url);
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Length', String.valueOf(jsonBody.length()));
        httpRequest.setHeader('Content-Type','application/json');
        httpRequest.setHeader('Authorization','Bearer ' + accessToken);
        httpRequest.setBody(jsonBody);
        Http http = new Http();
        HttpResponse response = http.send(httpRequest);
        
        Scan scan = (Scan) JSON.deserialize(response.getBody(), Scan.class);

        ScanBranchResponse result = new ScanBranchResponse();
        result.id = scan.id;
        result.status = scan.status;

        List<ScanBranchResponse> resultList = new List<ScanBranchResponse>();
        resultList.add(result);
        return resultList;
    }

    public class ScanBranchRequest{
        
        @InvocableVariable
        public String branchName;
    }

    public class ScanBranchResponse{
        
        @InvocableVariable
        public String id;

        @InvocableVariable
        public String status;

    }

}