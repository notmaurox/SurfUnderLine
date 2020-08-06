from django import forms
import datetime

from models import (
    COMPASS_DIRS, SURF_QUALITY, RANGE_1_TO_10, BEACH, READING_INCREMENT,
    THREE_HR_INCREMENTS
)

class ReportSurfSession(forms.Form):
    first_name = forms.CharField(
        label='First name',
        max_length=45,
        widget=forms.Textarea
    )
    last_name = forms.CharField(
        label='Last name',
        max_length=45,
        help_text='*must be pre-registered with SurfUnderLine',
        widget=forms.Textarea
    )
    your_skill_level = forms.ChoiceField(
        label='Skill level',
        choices=RANGE_1_TO_10,
        help_text="1 = noobie, 5 = Average joe, 10 = the Slater mane"
    )
    surf_spot = forms.ChoiceField(
        choices=[(object.name, object.name )for object in BEACH.objects.all()]
    )
    day = forms.DateField(initial=datetime.date.today)
    time = forms.ChoiceField(
        choices=THREE_HR_INCREMENTS,
        help_text='Pick a time closest to the middle point of your session'
    )
    surf_quality = forms.ChoiceField(
        label='Surf Quality',
        choices=SURF_QUALITY,
    )
    min_surf_height = forms.IntegerField(
        label='Smallest wave height'
    )
    max_surf_height = forms.IntegerField(
        label='Largest wave height'
    )
    comment = forms.CharField(
        label='Comment',
        max_length=150,
        help_text='*any notes on your session?',
        widget=forms.Textarea
    )

    def clean_first_name(self):
        data = self.cleaned_data['first_name']
        if data == 'NAUGHTY':
            raise ValidationError(_('bad boy'))
        return data
        
    def __init__(self, *args, **kwargs):
        # Call to ModelForm constructor
        super(ReportSurfSession, self).__init__(*args, **kwargs) 
        fields_to_adjust = [
            'first_name', 'last_name', 'your_skill_level', 'comment', 'time'
        ]
        for field in fields_to_adjust:
            self.fields[field].widget.attrs['cols'] = 45
            self.fields[field].widget.attrs['rows'] = 1
            self.fields[field].widget.attrs['size'] = 1
            self.fields[field].help_text = '</br>'+self.fields[field].help_text

        self.fields['comment'].widget.attrs['cols'] = 50
        self.fields['comment'].widget.attrs['rows'] = 3
        self.fields['surf_quality'].help_text = """
            </br>*Surfline rating scale
        """.replace("            ","")
        # self.fields['first_name'].widget.attrs['title'] = 'title'