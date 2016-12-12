public class ApplicationException extends Exception {

    /* 
        Salesforce code coverage doesn't calculate this extended class unless we create our own constructor.
        We need to call the below constructor in our unit test to register code coverage.
    */
    public ApplicationException(String internalMessage, String externalMessage)
    {
        this(externalMessage);
    }

}