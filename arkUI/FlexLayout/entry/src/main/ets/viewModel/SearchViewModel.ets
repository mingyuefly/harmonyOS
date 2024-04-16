
class SearchViewModel {
  /**
   * Get search arr data.
   */
  getSearchArrData() {
    let listItems: Array<string> = [
      'Text', 'Button', 'TextField', 'Image',
      'Switch', 'Checkbox', 'RadioButton',
      'ProgressBar', 'ScrollView'
    ];
    return listItems;
  }
}

export default new SearchViewModel();

