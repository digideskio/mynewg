FactoryGirl.define do
  factory :attachment do

    factory :gallery_attachment do
        attachable_type { 'GalleryPhoto' }
    end

    factory :cover_attachment do
        attachable_type { 'CoverPhoto' }
    end

    factory :event_hero_attachment do
        attachable_type { 'EventHeroPhoto' }
    end
  end
end
