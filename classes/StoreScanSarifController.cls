public with sharing class StoreScanSarifController {

    @InvocableMethod(label='Store Scan Sarif' description='Store Scan Sarif')
    public static void saveSarifAttachment(List<StoreScanSarifRequest> request){
        
        String sarifUrl = request.get(0).sarifUrl;
        
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(sarifUrl);
        httpRequest.setMethod('GET');
        httpRequest.setTimeout(60000);
        Http http = new Http();
        HttpResponse response = http.send(httpRequest);
        
        Blob body = response.getBodyAsBlob();
        String filename = 'SARIF-'+ request.get(0).title + '.json';
        Attachment att = new Attachment(Name = filename, Body = body, ContentType = 'application/sarif+json', ParentId=request.get(0).recordId);
        insert att;
    }

    public class StoreScanSarifRequest{
        
        @InvocableVariable
        public String sarifUrl;

        @InvocableVariable
        public String recordId;

        @InvocableVariable
        public String title;

    }


}