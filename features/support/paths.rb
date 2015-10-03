  module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
      when /^register$/ then
        new_user_registration_path
      when /^the (Goalify )?Home\s?page$/ then
        root_path
      when /^the My Goals page$/ then
        pages_my_goals_path
      when /^the About page$/ then
        pages_about_path
      when /^the new Goal page$/ then
        new_goal_path
      when /^the edit Goal page for "(.*)"$/ then
        edit_goal_path Goal.find_by(title: $1).id
      when /^the show Goal page for "(.*)"$/ then
        goal_path Goal.find_by(title: $1).id
      when /^the Sign Up page$/ then
        new_user_registration_path
      when /^The Sign In page$/ then
        new_user_session_path
      when /^the Goal index page$/ then
        goals_path
      when /^the User index page$/ then
        users_path
      when /^the User profile page$/ then
        user_path @user
      when /^another User's profile$/ then
        user_path

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #   when /^(.*)'s profile page$/i
      #     user_profile_path(User.find_by_login($1))

      else
        begin
          page_name =~ /^the (.*) page$/
          path_components = $1.split(/\s+/)
          send(path_components.push('path').join('_').to_sym)
        rescue NoMethodError, ArgumentError
          raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
                    "Now, go and add a mapping in #{__FILE__}"
        end
    end
  end

  def click_on(link_name)
    case link_name
      when /^New Goal$/ then
        visit new_goal_path
      when /^All Goals$/ then
        visit goals_path
      when /^Sign Up$/ then
        visit new_user_registration_path
      when /^Deactivate User$/ then
        visit cancel_user_registration_path
    end
  end
end

World NavigationHelpers
