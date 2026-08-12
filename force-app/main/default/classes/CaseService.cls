/**
 * Service class for Case operations.
 */
public with sharing class CaseService {
    
    /**
     * Closes the specified cases by setting their Reason field.
     *
     * @param caseIds the set of Case record IDs to update
     * @param caseReason the reason to assign to the cases
     * @throws CaseServiceException when case IDs or reason are not provided
     */
    public static void closeCases(Set<Id> caseIds, String caseReason){
        //validate parameters
        if(caseIds == null || caseIds.size() == 0){
            throw new CaseServiceException('Cases not specified.');
        }
        if(String.isBlank(caseReason)){
            throw new CaseServiceException('Reason not specified.'); 
        }
        List<Case> casesToUpdate = new List<Case>();
        for(Case someCase : [SELECT Id, Status,Reason FROM Case WHERE Id IN :caseIds WITH USER_MODE] ){
            someCase.Reason = caseReason;
            someCase.Status = 'Closed';
            casesToUpdate.add(someCase);
        }

        // Update the database
        SavePoint sp = Database.setSavePoint();
        try {
            update casesToUpdate;
        } catch (Exception e) {
            // Rollback
            Database.rollback(sp);
            // Throw exception on to caller
            throw e;
        }
    }

    /**
     * Exception thrown by CaseService when input validation fails.
     */
    public class CaseServiceException extends Exception {}
}