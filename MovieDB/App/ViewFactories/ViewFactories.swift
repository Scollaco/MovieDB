import MoviesFeature
import SeriesFeature
import SearchFeature
import Details
import Foundation

let moviesViewsFactory: MoviesViewFactory = {
  MoviesViewFactory(dependencies: MovieDBApp.dependencies)
}()

let seriesViewsFactory: SeriesViewFactory = {
  SeriesViewFactory(dependencies: MovieDBApp.dependencies)
}()

let searchViewFactory: SearchViewFactory = {
  SearchViewFactory(dependencies: MovieDBApp.dependencies)
}()

let detailsViewFactory: DetailsViewFactory = {
  DetailsViewFactory(dependencies: MovieDBApp.dependencies)
}()
