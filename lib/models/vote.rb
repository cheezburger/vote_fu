class Vote < ActiveRecord::Base
  
  # NOTE: Votes belong to the "voteable" interface, and also to voters
  belongs_to :voteable, :polymorphic => true
  belongs_to :voter,    :polymorphic => true
  
  attr_accessible :vote, :voter, :voteable

  # Uncomment this to limit users to a single vote on each item. 
  validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_type, :voter_id]
  
  def self.descending
    order("created_at DESC")
  end
  
  def self.for_voter(voter)
    where("voter_id = ? AND voter_type = ?", voter.id, voter.type.name)
  end
  
  def self.for_voteable(voteable)
    where("voteable_id = ? AND voteable_type = ?", voteable.id, voteable.type.name)
  end
  
  def self.recent(time=nil)
    where("created_at > ?", (time || 2.weeks.ago).to_s(:db))
  end

end