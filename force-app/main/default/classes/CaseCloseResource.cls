/**
 * REST resource for closing a Case record.
 *
 * Supports POST requests to close a specific Case using the supplied reason.
 */
@RestResource(urlMapping='/case/*/close')
global with sharing class CaseCloseResource {

    /**
     * Handles the REST POST request to close a Case.
     *
     * @param caseReason the reason used to close the Case
     */
    @HttpPost
    global static void closeCase(String caseReason){

        // Parse context
        RestRequest req = RestContext.request;
        String[] uriParts = req.requestURI.split('/');
        Id caseId = uriParts[2];

        CaseService.closeCases(
            new Set<Id>{caseId}, caseReason);
    }
}