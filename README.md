# Micro-Phonebook

This was the additional resources in the building with active record section
of the Odin Project and it covers Polymorphism.

### http://tutorials.jumpstartlab.com/topics/models/polymorphism.html

Other good resources are i've found ...

### http://6ftdan.com/allyourdev/2015/02/10/rails-polymorphic-models/

### https://richonrails.com/articles/polymorphic-associations-in-rails

### http://karimbutt.github.io/blog/2015/01/03/step-by-step-guide-to-polymorphic-associations-in-rails/

Say we want to implement this:

- A Person
- A Company
- A PhoneNumber that can belong to a Person or a Company

# The WRONG way to do it ...

A naive implementation would be to add both person_id and company_id columns to 
the phone_numbers table. Then in the model:


    class PhoneNumber < ActiveRecord::Base
    	belongs_to :person
    	belongs_to :company
    	belongs_to ...
    	belongs_to ....
    	belongs_to .....
    end

This is wrong because it implies that a single PhoneNumber can connect to both a 
Person and a Company. Furthermore, as you add more classes that can have phone 
numbers, you’ll have to keep adding ( belongs to ... ) columns to phone_numbers

## The CORRECT Database Structure

    In this domain, contact would be a good generalization of Person and Company. 
    Our phone_numbers table should have columns contact_id and contact_type


### NOTE: Telephone numbers are strings of digit characters, they are not integers

    |id| number       |contact_id|contact_type|
    | 1| "2223334444" | 2        | "Person"   |
    | 2| "5554443333" | 3        | "Person"   |
    | 3| "6667774444" | 3        | "Company"  |

# Implementation using One-to-One (has_one)

## Person 

- id:integer 				[present]
- number:string 			[present]
- first_name:string 		[present]

- has_one :phone_number, as: :contact

### Generate the Person model
rails generate model Person number:string first_name:string

## Company

- id:integer 				[present]
- number:string 			[present]
- company_name:string 		[present]

- has_one :phone_number, as: :contact

### Generate the Company model
rails generate model Company number:string company_name:string

## PhoneNumber

- id:integer 				[present]
- number:string 			[present]
- contact_id:integer 		[present, index]
- contact_type:string 		[present]

- belongs_to :contact, polymorphic: true

### Generate the PhoneNumber model
rails generate model PhoneNumber number:string contact_id:integer contact_type:string

    Add the index to the migration ...

    add_index :phone_numbers, :contact_id

# Usage in the views

    Assuming we have an instance of these classes  @phone_number, @person, or @company:

@company.phone_number
@person.phone_number
@phone_number.contact

# Implementation using One-to-Many (has_many)

    We change has_one to has_many and pluralize the object name to :phone_numbers. 
    and nothing else changes!

## Person 

- first_name:string 		[present]
- number:integer 			[present]

- has_many :phone_numbers, as: :contact

## Testing in rails console

    Person.create(first_name: 'Jake', last_name: 'Black')
    PhoneNumber.create(contact: Person.first, number: '0101567891')
    PhoneNumber.create(contact: Person.first, number: '0101476325')

    Person.create(first_name: 'Roger', last_name: 'Red')
    PhoneNumber.create(contact: Person.find(2), number: '0202346268')
    PhoneNumber.create(contact: Person.find(2), number: '0202951694')

    Company.create(company_name: 'Food Company')
    PhoneNumber.create(contact: Company.first, number: '04277836021')

    Company.create(company_name: 'Car Company')
    PhoneNumber.create(contact: Company.find(2), number: '06399836021')

- company = Company.first
- person = Person.first
- phone_number = PhoneNumber.first

- company.phone_numbers
- company.company_name

- person.phone_numbers
- person.first_name

### I still need to figure this one out!!!

phone_number.contact

Should be an instance of Person or Company

But ...

- phone_number.contact_type

Returns Person or Company

- person2 = Person.find(2).phone_numbers