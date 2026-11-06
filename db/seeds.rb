# This file seeds the database with a starting set of users and tasks. Load it
# with `bin/rails db:seed` (or alongside db:create via `bin/rails db:setup`).
#
# All accounts share the password "abc123" so any of them can be used to log in.

[
  "Ada Lovelace",
  "Grace Hopper",
  "Katherine Johnson",
  "Alan Turing",
  "Edsger Dijkstra"
].each_with_index do |name, index|
  User.where(email: "user#{index + 1}@tern.travel").first_or_create!(
    name: name,
    password: "abc123",
    password_confirmation: "abc123"
  )
end

# Titles intentionally vary in casing, length, and shared substrings (several
# "Book ...", two "... client ...") so filtering and sorting have something real
# to chew on. A few descriptions are left blank to exercise the index view's
# nil-safe truncation.
tasks = [
  {title: "Book flights to Lisbon", completed_at: Time.current, description: "Outbound May 3, return May 17. Aisle seats for both legs."},
  {title: "Book hotel in Kyoto", description: "Ryokan near Gion, 4 nights, breakfast included."},
  {title: "Book airport transfer", description: nil},
  {title: "Confirm client itinerary", description: "Send the day-by-day plan to the Hendricks party for sign-off."},
  {title: "Email client welcome packet", completed_at: Time.current, description: "Visa reminders, packing list, emergency contacts."},
  {title: "Renew passport", description: "Expedited — current one expires in under six months."},
  {title: "Update travel insurance", description: nil},
  {title: "Draft Q3 trip budget", description: "Roll up supplier quotes and a 12% contingency."},
  {title: "Review supplier contracts", completed_at: Time.current, description: "Check cancellation windows before the deposit deadline."},
  {title: "Schedule team offsite", description: "Two days, somewhere reachable by train for everyone."},
  {title: "Reconcile expense report", description: "March card statement against the receipts folder."},
  {title: "Plan Patagonia route", description: "El Chaltén to Torres del Paine, padding for weather days."},
  {title: "Order currency for Japan", description: nil},
  {title: "Sync with ground operator", completed_at: Time.current, description: "Confirm the driver and guide for the Marrakech leg."},
  {title: "Archive old itineraries", description: "Anything from last season can move to cold storage."},
  {title: "follow up with Lisbon hotel", description: "Lowercase on purpose — still waiting on the room upgrade."}
]

tasks.each do |attributes|
  Task.where(title: attributes[:title]).first_or_create!(attributes.except(:title))
end

legacy_tasks = [
  {title: "Buy tickets: book the 9am AA flight to Cancun"},
  {title: "Call hotel: confirm the late checkout for the Rivera party"},
  {title: "Passport: renew before the Japan trip", completed_at: Time.current},
  {title: "Insurance: add the Patagonia leg to the policy"}
]

legacy_tasks.each do |attributes|
  Task.where(title: attributes[:title]).first_or_create!(attributes.except(:title))
end
