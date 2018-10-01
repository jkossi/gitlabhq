require 'spec_helper'

describe 'User Cluster', :js do
  include GoogleApi::CloudPlatformHelpers

  let(:project) { create(:project) }
  let(:user) { create(:user) }

  before do
    project.add_maintainer(user)
    gitlab_sign_in(user)
    allow(Projects::ClustersController).to receive(:STATUS_POLLING_INTERVAL) { 100 }
  end

  context 'when user does not have a cluster and visits cluster index page' do
    before do
      visit project_clusters_path(project)

      click_link 'Add Kubernetes cluster'
      click_link 'Add existing cluster'
    end

    context 'when user filled form with valid parameters' do
      shared_examples 'valid cluster user form' do
        it 'user sees a cluster details page' do
          subject

          expect(page).to have_content('Kubernetes cluster integration')
          expect(page.find_field('cluster[name]').value).to eq('dev-cluster')
          expect(page.find_field('cluster[platform_kubernetes_attributes][api_url]').value)
            .to have_content('http://example.com')
          expect(page.find_field('cluster[platform_kubernetes_attributes][token]').value)
            .to have_content('my-token')
        end
      end

      before do
        fill_in 'cluster_name', with: 'dev-cluster'
        fill_in 'cluster_platform_kubernetes_attributes_api_url', with: 'http://example.com'
        fill_in 'cluster_platform_kubernetes_attributes_token', with: 'my-token'
      end

      subject { click_button 'Add Kubernetes cluster' }

      it_behaves_like 'valid cluster user form'

      context 'rbac_clusters feature flag is enabled' do
        before do
          stub_feature_flags(rbac_clusters: true)

          check 'cluster_platform_kubernetes_attributes_authorization_type'
        end

        it_behaves_like 'valid cluster user form'

        it 'user sees a cluster details page with RBAC enabled' do
          subject

          expect(page.find_field('cluster[platform_kubernetes_attributes][authorization_type]', disabled: true)).to be_checked
        end
      end
    end

    context 'when user filled form with invalid parameters' do
      before do
        click_button 'Add Kubernetes cluster'
      end

      it 'user sees a validation error' do
        expect(page).to have_css('#error_explanation')
      end
    end
  end

  context 'when user does have a cluster and visits cluster page' do
    let(:cluster) { create(:cluster, :provided_by_user, projects: [project]) }

    before do
      visit project_cluster_path(project, cluster)
    end

    it 'user sees a cluster details page' do
      expect(page).to have_button('Save changes')
    end

    context 'when user disables the cluster' do
      before do
        page.find(:css, '.js-cluster-enable-toggle-area .js-project-feature-toggle').click
        page.within('#cluster-integration') { click_button 'Save changes' }
      end

      it 'user sees the successful message' do
        expect(page).to have_content('Kubernetes cluster was successfully updated.')
      end
    end

    context 'when user changes cluster parameters' do
      before do
        fill_in 'cluster_name', with: 'my-dev-cluster'
        fill_in 'cluster_platform_kubernetes_attributes_namespace', with: 'my-namespace'
        page.within('#js-cluster-details') { click_button 'Save changes' }
      end

      it 'user sees the successful message' do
        expect(page).to have_content('Kubernetes cluster was successfully updated.')
        expect(cluster.reload.name).to eq('my-dev-cluster')
        expect(cluster.reload.platform_kubernetes.namespace).to eq('my-namespace')
      end
    end

    context 'when user destroy the cluster' do
      before do
        page.accept_confirm do
          click_link 'Remove integration'
        end
      end

      it 'user sees creation form with the successful message' do
        expect(page).to have_content('Kubernetes cluster integration was successfully removed.')
        expect(page).to have_link('Add Kubernetes cluster')
      end
    end
  end
end
