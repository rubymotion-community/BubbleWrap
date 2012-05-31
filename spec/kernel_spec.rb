describe "Kernel" do
  it "should return current locale" do
    current_locale.should.not.be.nil
    current_locale.should.be.is_a?(NSLocale)
  end
end