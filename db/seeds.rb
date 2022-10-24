# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

%w[langurage math programming algorithms].each do |course|
  Course.create(title: course, instructor: "#{course} teacher", description: "Happy for Learning")
end

Course.all.each do |course|
  1.upto(5) do |index|
    course.chapters.create(title: "#{course.title} - Chapter #{index}", sequence: index)
  end
end

Chapter.all.each do |chapter|
  1.upto(5) do |index|
    chapter.lessons.create(
      title: "#{chapter.title} - Lesson #{index}",
      description: "Lesson #{index} - description",
      content: "This is Lesson #{index} content",
      sequence: index
    )
  end
end
