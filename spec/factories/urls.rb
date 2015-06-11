FactoryGirl.define do
  factory :url do
    original 'http://www.example.com/'
    delete_token 'delete'
    views 0

    trait :confirm_delete do
      delete_token_confirmation 'delete'
    end

    factory :url_with_confirmed_delete, traits: [:confirm_delete]
  end
end
