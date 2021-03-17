require "application_system_test_case"

class FilersTest < ApplicationSystemTestCase
  setup do
    @filer = filers(:one)
  end

  test "visiting the index" do
    visit filers_url
    assert_selector "h1", text: "Filers"
  end

  test "creating a Filer" do
    visit filers_url
    click_on "New Filer"

    fill_in "Address", with: @filer.address
    fill_in "City", with: @filer.city
    fill_in "Ein", with: @filer.ein
    fill_in "Filename", with: @filer.filename
    fill_in "Name", with: @filer.name
    fill_in "State", with: @filer.state
    fill_in "Uploaded at", with: @filer.uploaded_at
    fill_in "Zip", with: @filer.zip
    click_on "Create Filer"

    assert_text "Filer was successfully created"
    click_on "Back"
  end

  test "updating a Filer" do
    visit filers_url
    click_on "Edit", match: :first

    fill_in "Address", with: @filer.address
    fill_in "City", with: @filer.city
    fill_in "Ein", with: @filer.ein
    fill_in "Filename", with: @filer.filename
    fill_in "Name", with: @filer.name
    fill_in "State", with: @filer.state
    fill_in "Uploaded at", with: @filer.uploaded_at
    fill_in "Zip", with: @filer.zip
    click_on "Update Filer"

    assert_text "Filer was successfully updated"
    click_on "Back"
  end

  test "destroying a Filer" do
    visit filers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Filer was successfully destroyed"
  end
end
