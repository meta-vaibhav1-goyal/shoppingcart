public class StringListTest {
	
    public static List<String> generateStringList(Integer n) {
        List<String> tests = new List<String>();
        
        for(Integer cnt = 0; cnt < n; cnt++) {
            String s = 'Test';
            tests.add(s + ' ' + cnt);
        }
        
        return tests;
    }
}