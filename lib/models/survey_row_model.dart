class SurveyRowModel {
  String surveyNo;
  String crop;

  double acre;
  double gunte;
  double subGunte;

  double amount;

  SurveyRowModel({
    this.surveyNo = '',
    this.crop = 'Arecanut',
    this.acre = 0,
    this.gunte = 0,
    this.subGunte = 0,
    this.amount = 0,
  });
}