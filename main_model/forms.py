from django import forms

from models import COMPASS_DIRS, SURF_QUALITY

class ReportSurfSession(forms.Form):
    first_name = forms.CharField(
        label='First_name',
        max_length=45,
        widget=forms.Textarea
    )
    last_name = forms.CharField(
        label='Last name',
        max_length=45,
        help_text='*must be pre-registered with SurfUnderLine',
        widget=forms.Textarea
    )
    surf_quality = forms.ChoiceField(
        label='Surf Quality',
        choices=SURF_QUALITY,
    )
    
    def clean_first_name(self):
        data = self.cleaned_data['first_name']
        
        if data == 'FUCK':
            raise ValidationError(_('bad boy'))
            
        return data
        
    def __init__(self, *args, **kwargs):
        # Call to ModelForm constructor
        super(ReportSurfSession, self).__init__(*args, **kwargs) 
        fields_to_adjust = [
            'first_name', 'last_name', 
        ]
        for field in fields_to_adjust:
            self.fields[field].widget.attrs['cols'] = 45
            self.fields[field].widget.attrs['rows'] = 1
            self.fields[field].widget.attrs['size'] = 1
            self.fields[field].help_text = '</br>'+self.fields[field].help_text

        self.fields['surf_quality'].help_text = """
            </br>*Surfline rating scale
        """.replace("            ","")
        # self.fields['first_name'].widget.attrs['title'] = 'title'