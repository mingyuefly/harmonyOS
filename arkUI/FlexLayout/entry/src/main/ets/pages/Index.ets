import StyleConstants from '../common/constants/StyleConstants';
import SearchInput from '../views/SearchInput';
import ClearSearch from '../views/ClearSearch';
import FlexLayout from '../views/FlexLayout';
import SearchViewModel from '../viewModel/SearchViewModel';

@Entry
@Component
struct Index {
  @State searchArr: Array<string> = SearchViewModel.getSearchArrData();

  build() {
    Column() {
      // Customized component of the search text box.
      SearchInput({ searchArr: this.searchArr });
      // Clear Search Records Custom Component.
      ClearSearch({ searchArr: this.searchArr });
      // Flexible Layout Customization Component.
      FlexLayout({ searchArr: this.searchArr });
    }
    .height(StyleConstants.FULL_PERCENT)
    .width(StyleConstants.FULL_PERCENT)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.index_background'))
  }
}