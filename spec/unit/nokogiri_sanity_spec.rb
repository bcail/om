require 'spec_helper'

describe "OM::XML::TermValueOperators" do
  
  describe "find_by_terms" do
    before(:each) do
      @article = OM::Samples::ModsArticle.from_xml( fixture( File.join("mods_articles","hydrangea_article1.xml") ) )
    end
  
    it "should do" do
      @article.find_by_terms({:journal=>0}).length.should == 1
    end
  end
  
  describe "update_values" do
    before(:each) do
      @article = OM::Samples::ModsArticle.from_xml( fixture( File.join("mods_articles","hydrangea_article1.xml") ) )
    end
  
    it "should respond with a hash of updated values and their indexes" do
      test_args = {[{"person"=>"0"},"description"]=>["mork", "york"]}      
      result = @article.update_values(test_args)
      result.should == {"person_0_description"=>["mork", "york"]}
    end
    
    it "should update the xml in the specified datastream and know that changes have been made" do
      @article.term_values({:person=>0}, :first_name).should == ["GIVEN NAMES"]
      test_args = {[{:person=>0}, :first_name]=>"Replacement FirstName"}
      @article.update_values(test_args)
      @article.term_values({:person=>0}, :first_name).should == ["Replacement FirstName"]
      @article.should be_changed
    end
    
    it "should update the xml according to the find_by_terms_and_values in the given hash" do
      terms_attributes = {[{":person"=>"0"}, "affiliation"]=>["affiliation1", "affiliation2", "affiliation3"]}
      result = @article.update_values(terms_attributes)
      result.should == {"person_0_affiliation"=>["affiliation1", "affiliation2", "affiliation3"]}
      
      # Trying again with a more complex update hash
      terms_attributes = {[{":person"=>"0"}, "affiliation"]=>["affiliation1", "affiliation2", "affiliation3"], [{:person=>1}, :last_name]=>"Andronicus", [{"person"=>"1"},:first_name]=>["Titus"],[{:person=>1},:role]=>["otherrole1","otherrole2"] }
      result = @article.update_values(terms_attributes)
      result.should == {"person_0_affiliation"=>["affiliation1", "affiliation2", "affiliation3"], "person_1_last_name"=>["Andronicus"],"person_1_first_name"=>["Titus"], "person_1_role"=>["otherrole1","otherrole2"]}
      @article.should be_changed
    end
    
    it "should work when you re-run the command" do
      terms_attributes = {[{":person"=>"0"}, "affiliation"]=>["affiliation1", "affiliation2", "affiliation3"]}
      result = @article.update_values(terms_attributes)
      @article.term_values( {":person"=>"0"}, "affiliation" ).should == ["affiliation1", "affiliation2", "affiliation3"]
      result.should == {"person_0_affiliation"=>["affiliation1", "affiliation2", "affiliation3"]}
      
      terms_attributes = {[{":person"=>"0"}, "affiliation"]=>["affiliation1", "affiliation2", "affiliation3"]}
      @article = OM::Samples::ModsArticle.from_xml( fixture( File.join("mods_articles","hydrangea_article1.xml") ) )
      result = @article.update_values(terms_attributes)
      @article.term_values( {":person"=>"0"}, "affiliation" ).should == ["affiliation1", "affiliation2", "affiliation3"]
      result.should == {"person_0_affiliation"=>["affiliation1", "affiliation2", "affiliation3"]}
      result = @article.update_values(terms_attributes)
      
      terms_attributes = {[{":person"=>"0"}, "affiliation"]=>["affiliation1", "affiliation2", "affiliation3"]}
      @article = OM::Samples::ModsArticle.from_xml( fixture( File.join("mods_articles","hydrangea_article1.xml") ) )
      result = @article.update_values(terms_attributes)
      @article.term_values( {":person"=>"0"}, "affiliation" ).should == ["affiliation1", "affiliation2", "affiliation3"]
      result.should == {"person_0_affiliation"=>["affiliation1", "affiliation2", "affiliation3"]}
      
      # Trying again with a more complex update hash
      terms_attributes = {[{":person"=>"0"}, "affiliation"]=>["affiliation1", "affiliation2", "affiliation3"], [{:person=>1}, :last_name]=>"Andronicus", [{"person"=>"1"},:first_name]=>["Titus"],[{:person=>1},:role]=>["otherrole1","otherrole2"] }
      result = @article.update_values(terms_attributes)
      result.should == {"person_0_affiliation"=>["affiliation1", "affiliation2", "affiliation3"], "person_1_last_name"=>["Andronicus"],"person_1_first_name"=>["Titus"], "person_1_role"=>["otherrole1", "otherrole2"]}
      @article.should be_changed
    end
  end
  

  
end
