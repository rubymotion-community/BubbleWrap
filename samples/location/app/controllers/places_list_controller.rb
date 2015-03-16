class PlacesListController < UITableViewController
  attr_accessor :places_list

  def viewDidLoad
    @places_list = []
    Places.load(self)
    view.dataSource = view.delegate = self
  end 

  def viewWillAppear(animated)
    view.reloadData
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @places_list.size
  end

  def reloadData
    view.reloadData
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:CellID)
    placeItem= @places_list[indexPath.row]
    cell.textLabel.text = placeItem
    cell
  end

end
