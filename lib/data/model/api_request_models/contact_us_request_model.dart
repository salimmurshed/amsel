class ContactUsRequestModel {
  final String firstName, lastName, email, news;
  final String? company;

  const ContactUsRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.news,
    this.company,
  });
}
