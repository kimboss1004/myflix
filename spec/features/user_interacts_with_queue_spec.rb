require 'spec_helper'

feature "user interacts with queue" do
  scenario 'user adds video to queue' do
    comedy = Fabricate(:category, title: "Comedies")
    adventure_time = Fabricate(:video, title: "Adventure Time", category: comedy)
    south_park = Fabricate(:video, title: "South Park", category: comedy)
    pokemon = Fabricate(:video, title: "Pokemon", category: comedy)
    sign_in

    click_on_video_image_link(adventure_time)
    expect(page).to have_content(adventure_time.title)
    
    click_link('+ My Queue')
    expect(page).to have_content(adventure_time.title)

    visit video_path(adventure_time)
    expect(page).not_to have_content('+ My Queue')

    visit video_path(south_park)
    click_link('+ My Queue')
    visit video_path(pokemon)
    click_link('+ My Queue')

    set_queue_position(adventure_time, 3)
    set_queue_position(south_park, 1)
    set_queue_position(pokemon, 2)
    click_button "update"

    expect_video_position_to_eq(adventure_time, 3)
    expect_video_position_to_eq(south_park, 1)
    expect_video_position_to_eq(pokemon, 2)
  end

  def click_on_video_image_link(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def set_queue_position(video, position)
    fill_in "video_#{video.id}", with: position
  end

  def expect_video_position_to_eq(video, position)
    expect(find("#video_#{video.id}").value).to eq("#{position}")
  end
end