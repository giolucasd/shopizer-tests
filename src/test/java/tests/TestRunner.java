package tests;

import com.intuit.karate.junit5.Karate;

class TestRunner {
    
    @Karate.Test
    Karate runTests() {
        return Karate.run("H3").relativeTo(getClass());
    }    

}
