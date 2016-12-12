@isTest
private class ApplicationException_Test {

    static testMethod void testException()
    {
        try
        {
            throw new ApplicationException('test', 'you broke it');
        }
        catch(Exception ex)
        {
            System.assert(ex.getMessage().contains('you broke it'));
        }
    }
    
    static testMethod void testExceptionAgain()
    {
        try
        {
            throw new ApplicationException('you broke it');
        }
        catch(Exception ex)
        {
            System.assert(ex.getMessage().contains('you broke it'));
        }
    }
}