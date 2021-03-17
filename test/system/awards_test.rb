require "application_system_test_case"

class AwardsTest < ApplicationSystemTestCase
  setup do
    @award = awards(:one)
  end

  test "visiting the index" do
    visit awards_url
    assert_selector "h1", text: "Awards"
  end

  test "creating a Award" do
    visit awards_url
    click_on "New Award"

    fill_in "Address", with: @award.address
    fill_in "Amount", with: @award.amount
    fill_in "City", with: @award.city
    fill_in "Ein", with: @award.ein
    fill_in "Filename", with: @award.filename
    fill_in "Filer ein", with: @award.filer_ein
    fill_in "Name", with: @award.name
    fill_in "Purpose", with: @award.purpose
    fill_in "State", with: @award.state
    fill_in "Uploaded at", with: @award.uploaded_at
    fill_in "Zip", with: @award.zip
    click_on "Create Award"

    assert_text "Award was successfully created"
    click_on "Back"
  end

  test "updating a Award" do
    visit awards_url
    click_on "Edit", match: :first

    fill_in "Address", with: @award.address
    fill_in "Amount", with: @award.amount
    fill_in "City", with: @award.city
    fill_in "Ein", with: @award.ein
    fill_in "Filename", with: @award.filename
    fill_in "Filer ein", with: @award.filer_ein
    fill_in "Name", with: @award.name
    fill_in "Purpose", with: @award.purpose
    fill_in "State", with: @award.state
    fill_in "Uploaded at", with: @award.uploaded_at
    fill_in "Zip", with: @award.zip
    click_on "Update Award"

    assert_text "Award was successfully updated"
    click_on "Back"
  end

  test "destroying a Award" do
    visit awards_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Award was successfully destroyed"
  end
end
